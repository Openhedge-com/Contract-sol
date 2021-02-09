// SPDX-License-Identifier: MIT

pragma solidity ^0.7.2;

import "./ERC20.sol";

contract HedgerParty {
    enum HedgerStatus {NEW, FUNDED, WITHDRAWN}
    HedgerStatus public status = HedgerStatus.NEW;

    // OpenHedge Primary Contract Address
    address public contractAddr;
    // User Ethereum Address
    address public account;
    // Asset Address, Use 0x0/address(0) for ETH
    address public assetAddr;
    // Asset code/symbol/ticker
    string public assetCode;
    // Scale/precision value for asset
    uint8 public assetScale;
    // Amount of asset value
    uint256 public amount;
    // Timestamp: funded on
    uint256 public fundedOn;
    // Timestamp: withdrawn on
    uint256 public withdrawnOn;

    // Constructor for Hedger object
    constructor(address _contract) {
        contractAddr = _contract;
        reset();
    }

    // Reset hedger object
    function reset() public {
        status = HedgerStatus.NEW;
        account = address(0);
        assetAddr = address(0);
        assetCode = "";
        assetScale = 0;
        amount = 0;
        fundedOn = 0;
        withdrawnOn = 0;
    }

    // Reserve this hedger object
    function reserve(address _asset, uint256 _amount) public {
        status = HedgerStatus.NEW;
        if (_asset == address(0)) {// Is ETH
            assetAddr = address(0);
            assetCode = "ETH";
            assetScale = 18;
        } else {
            assetAddr = _asset;
            assetCode = ERC20(_asset).symbol();
            assetScale = ERC20(_asset).decimals();
        }

        amount = _amount;
    }

    // Set address of hedger party
    function setUserAccount(address _user) public {
        require(status == HedgerStatus.NEW);
        account = _user;
    }

    // Internal method to retrieve uint256 balance
    function getBalance() public view returns (uint256) {
        if (assetAddr == address(0)) {
            return contractAddr.balance;
        } else {
            (bool success, bytes memory tokenBalance) = assetAddr.staticcall(abi.encodeWithSignature("balanceOf(address)", contractAddr));
            require(success);
            return abi.decode(tokenBalance, (uint256));
        }
    }

    // Status of this object is "FUNDED" ?
    function isFunded() public view returns (bool) {
        return status == HedgerStatus.FUNDED;
    }

    // Get current object as string
    function getStatusStr() public view returns (string memory) {
        uint currentStatus = uint(status);
        if (currentStatus == 0) return "NEW";
        if (currentStatus == 1) return "FUNDED";
        if (currentStatus == 2) return "WITHDRAWN";

        revert("Unknown/Invalid HedgerStatus status");
    }

    // Marks as funded
    function markAsFunded() public {
        require(status == HedgerStatus.NEW);
        status = HedgerStatus.FUNDED;
        fundedOn = block.timestamp;
    }

    // Marks as withdrawn
    function markWithdrawn() public {
        require(status == HedgerStatus.FUNDED);
        status = HedgerStatus.WITHDRAWN;
        withdrawnOn = block.timestamp;
    }
}