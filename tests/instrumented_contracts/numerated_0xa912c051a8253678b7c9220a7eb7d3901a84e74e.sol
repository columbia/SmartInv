1 //
2 //     Multisend
3 //  Crypto Duel Coin Multisend
4 //
5 //       Crypto Duel Coin (CDC) is a cryptocurrency for online game and online casino. Our goal is very simple. It is create and operate an online game website   where the dedicated token is used. We will develop a lot of exciting games such as cards, roulette, chess, board games and original games and build the game website where people around the world can feel free to join.
6 
7 // 
8 //     INFORMATION
9 //  Name: Crypto Duel Coin 
10 //  Symbol: CDC
11 //  Decimal: 18
12 //  Supply: 40,000,000,000
13 // 
14 //
15 //
16 //
17 //
18 //  Website = http://cryptoduelcoin.com/   Twitter = https://twitter.com/CryptoDuelCoin
19 //
20 //
21 //  Telegram = https://t.me/CryptoDuelCoin  Medium = https://medium.com/crypto-duel-coin
22 //
23 //
24 // 
25 // 
26 //
27 // Crypto Duel Coin 
28 
29 
30 pragma solidity ^0.4.11;
31 
32 /**
33  * @title Ownable
34  * @dev The Ownable contract has an owner address, and provides basic authorization control 
35  * functions, this simplifies the implementation of "user permissions". 
36  */
37 contract Ownable {
38   address public owner;
39 
40   function Ownable() {
41     owner = msg.sender;
42   }
43  
44   modifier onlyOwner() {
45     if (msg.sender != owner) {
46       revert();
47     }
48     _;
49   }
50  
51   function transferOwnership(address newOwner) onlyOwner {
52     if (newOwner != address(0)) {
53       owner = newOwner;
54     }
55   }
56 
57 }
58 
59 contract ERC20Basic {
60   uint public totalSupply;
61   function balanceOf(address who) constant returns (uint);
62   function transfer(address to, uint value);
63   event Transfer(address indexed from, address indexed to, uint value);
64 }
65  
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) constant returns (uint);
68   function transferFrom(address from, address to, uint value);
69   function approve(address spender, uint value);
70   event Approval(address indexed owner, address indexed spender, uint value);
71 }
72 
73 contract CyyptoDuelCoin is Ownable {
74 
75     function multisend(address _tokenAddr, address[] dests, uint256[] values)
76     onlyOwner
77     returns (uint256) {
78         uint256 i = 0;
79         while (i < dests.length) {
80            ERC20(_tokenAddr).transfer(dests[i], values[i]);
81            i += 1;
82         }
83         return(i);
84     }
85 }