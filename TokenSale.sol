// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyToken.sol";

contract TokenSale {
    address payable public admin;
    MyToken public token;
    uint public tokenPrice;

    event TokenPurchased(address indexed buyer, uint amount);

    constructor(MyToken _token, uint _tokenPrice) {
        admin = payable(msg.sender);
        token = _token;
        tokenPrice = _tokenPrice;
    }

    receive() external payable {
        buyTokens();
    }

    function buyTokens() public payable {
        require(msg.value > 0, "SEND ETH TO BUY TOKENS");
        uint tokensToBuy = msg.value / tokenPrice;
        require(token.balanceOf(address(this)) >= tokensToBuy, "NOT ENOUGH TOKENS IN CONTRACT");
        token.transfer(msg.sender, tokensToBuy);
        emit TokenPurchased(msg.sender, tokensToBuy);
    }

    function withdrawETH() public {
        require(msg.sender == admin, "ONLY ADMIN CAN WITHDRAW");
        admin.transfer(address(this).balance);
    }

    function endSale() public {
        require(msg.sender == admin, "ONLY ADMIN CAN END SALE");
        uint remainingTokens = token.balanceOf(address(this));
        token.transfer(admin, remainingTokens);
        withdrawETH();
    }
}