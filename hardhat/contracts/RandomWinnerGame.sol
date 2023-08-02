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

    //EVENTS
    // emitted when the game starts
    event GameStarted(uint256 gameId, uint8 maxPlayers, uint256 entryFee);

    // emitted when someone joins a game
    event PlayerJoined(uint256 gameId, address player);

    // event when the game ends
    event GameEnded(uint256 gameId, address winner, bytes32 requestId);

    /**
    * constructor inherits a VRFConsumerBase and initiates the values for keyHash, fee and gameStarted
    * @param vrfCoordinator address of VRFCoordinator contract
    * @param linkToken address of LINK token contract
    * @param vrfFee the amount of LINK to send with the request
    * @param vrfKeyHash ID of public key against which randomness is generated
    */
    constructor (address vrfCoordinator, address linkToken, bytes32 vrfKeyHash, uint256 vrfFee) VRFConsumerBase(vrfCoordinator, linkToken) {
        keyHash = vrfKeyHash;
        fee = vrfFee;
        gameStarted = false;
    }
}