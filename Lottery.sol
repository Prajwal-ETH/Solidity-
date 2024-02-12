// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 <=0.9.0;

contract Lottery {
    address public manager;
    address payable[] public participants;
    address public winner;

    constructor() {
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 1 ether, "Please send exactly 1 Ether to participate");
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint256) {
        require(msg.sender == manager, "Only the manager can view the balance");
        return address(this).balance;
    }

    function random() public view returns (uint) {
        return uint(keccak256(abi.encode(block.difficulty, block.timestamp, participants)));
    }

    function selectWinner() public {
        require(msg.sender == manager, "Only the manager can select a winner");
        require(participants.length >= 3, "Not enough participants to select a winner");

        uint r = random();
        address payable selectedWinner;
        uint index = r % participants.length;
        selectedWinner = participants[index];
        winner = selectedWinner; // Store the winner's address
        selectedWinner.transfer(getBalance());
        participants = new address payable[](0);
    }

    // Function to retrieve the address of the winner
    function getWinner() public view returns (address) {
        require(winner != address(0), "No winner has been selected yet");
        return winner;
    }
}
