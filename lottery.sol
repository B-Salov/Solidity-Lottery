// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery{
    address payable[] public players;
    address public manager;


    constructor(){
        manager = msg.sender;
    }

    receive() external payable{
        require(msg.sender != manager);
        require(msg.value == 0.1 ether);  // Min 0.1 eth to paticipate
        players.push(payable(msg.sender));  // Add player
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender)));
    }

    function pickWinner() public{
        require(msg.sender == manager);  // Only manager have access to the lottery
        require(players.length >= 2);  // Min 2 players

        // Choose a winner
        uint r = random();
        address payable winner;

        uint index = r % players.length;
        winner = players[index];

        // Manager have 10% fee
        uint fee = (getBalance() * 10) / 100;
        uint prize = (getBalance() * 90) / 100;

        
        winner.transfer(prize);
        payable(manager).transfer(fee);

        players = new address payable[](0);  // resetting the lottery
    }
}


