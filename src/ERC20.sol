// SPDX-License-Identifier: MIT

pragma solidity ^0.7.2;

interface ERC20 {
    function balanceOf(address tokenOwner) external view returns (uint balance);

    function allowance(address tokenOwner, address spender) external view returns (uint remaining);

    function transfer(address to, uint tokens) external;

    function approve(address spender, uint tokens) external returns (bool success);

    function transferFrom(address from, address to, uint tokens) external;

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
