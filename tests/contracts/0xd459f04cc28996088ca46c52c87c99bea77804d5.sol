/**
 * BRRR.LIVE - Building generational wealth, together!
 *
 * With $BRRR we band together to build generational wealth for a random holder every day, forever.
 * Provably fair & fully on-chain.
 *
 *
 * HOW IT WORKS
 * Hold 100K $BRRR (0.1%) to join every daily game forever.
 * No betting, no losing $ETH, just hold to enter any game.
 * Every day, forever, a random holder automatically gets 50% of the previous day's total revenue.
 *  Total revenue include $BRRR volume tax, and literally everything else we make in the future.
 *
 *
 * Website: https://brrr.live
 * Twitter: https://twitter.com/brrr_live
 * Telegram: https://t.me/brrr_live
 * 
 * 
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract BrrrGame {

    IERC20 brrrToken;
    address public owner;
    uint public minHold;
    uint public maxTickets;
    uint public current_game;
    bool public game_active;
    uint counter = 1;
    mapping(uint => address[]) public GameToTickets;

    mapping(uint => mapping(address => uint)) GameToPlayerTickets;
    mapping(uint => uint) public GameToPrize;

    constructor() {
        owner = msg.sender;
        minHold = 100000 * 10** 9;
        maxTickets = 5;
        game_active = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not authorized");
        _;
    }

    receive() external payable {
    }

    function ticketsInGame(uint game_id) external view returns (address[] memory)
    {
        return GameToTickets[game_id];
    }

    function playerTicketsInGame(uint game_id, address addy) external view returns (uint)
    {
        return GameToPlayerTickets[game_id][addy];
    }

    function toggleGame() external onlyOwner() {
        game_active = !game_active;
    }

    function updateMaxTickets(uint _maxTickets) external onlyOwner() {
        maxTickets = _maxTickets;
    }

    function updateMinHold(uint _minHold) external onlyOwner() {
        minHold = _minHold * 10** 9;
    }

    function setTokenAddress(address payable _tokenAddress) external onlyOwner() {
       brrrToken = IERC20(address(_tokenAddress));
    }

    function joinGame() external 
    {
        require(game_active == true,"The game is currently inactive, try again later");
        require(brrrToken.balanceOf(msg.sender) >= minHold,"You don't hold enough $BRRR to join the current game");
        require(GameToPlayerTickets[current_game][msg.sender] == 0,"You have already joined the current game");
        
        uint ticket_amount = brrrToken.balanceOf(msg.sender) / minHold;

        if(ticket_amount > maxTickets)
        {
            ticket_amount = maxTickets;
        }

        for(uint i; i < ticket_amount; i++)
        {
            GameToTickets[current_game].push(msg.sender);
        }
        GameToPlayerTickets[current_game][msg.sender] = ticket_amount;
    }

    function GoBrrr() onlyOwner() external payable
    {
        if(GameToTickets[current_game].length > 0)
        {
            address payable winner;
            if(GameToTickets[current_game].length == 1){
                winner = payable(GameToTickets[current_game][0]);
            }
            else 
            {
                winner = payable(GameToTickets[current_game][randomNumber()]);
            }

            if(brrrToken.balanceOf(winner) >= (GameToPlayerTickets[current_game][winner] * minHold))
            {
                GameToPrize[current_game] = address(this).balance;
                winner.transfer(address(this).balance);
            }
            
        }
        current_game++;
    }

    function emergencyWithdrawal() external onlyOwner {
        (bool success, ) = msg.sender.call{ value: address(this).balance } ("");
        require(success, "Transfer failed.");
    }

    function randomNumber() internal returns (uint) 
    {
        counter++;
        uint random = uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, counter, GameToTickets[current_game].length, gasleft()))) % GameToTickets[current_game].length;
        return random;
    }

}