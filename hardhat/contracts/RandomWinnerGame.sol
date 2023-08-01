// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract RandomWinnerGame is VRFConsumerBase, Ownable {

    // the amount of LINK to send with the request
    uint256 public fee;

    // ID of a public key against which randomness is generated
    bytes32 public keyHash;

    // address of the players
    address[] public players;

    // max number of players in one game
    uint8 maxPlayers;

    // variable to indicate if the game has started or not
    bool public gameStarted;

    // fees for entering the game
    uint256 entryFee;

    // current game ID
    uint256 public gameId; 
}