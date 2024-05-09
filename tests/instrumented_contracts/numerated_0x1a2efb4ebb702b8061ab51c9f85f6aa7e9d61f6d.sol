1 pragma solidity ^0.4.10;
2 
3 // Token selling smart contract
4 // Inspired by https://github.com/bokkypoobah/TokenTrader
5 
6 // https://github.com/ethereum/EIPs/issues/20
7 contract ERC20 {
8     function totalSupply() constant returns (uint totalSupply);
9     function balanceOf(address _owner) constant returns (uint balance);
10     function transfer(address _to, uint _value) returns (bool success);
11     function transferFrom(address _from, address _to, uint _value) returns (bool success);
12     function approve(address _spender, uint _value) returns (bool success);
13     function allowance(address _owner, address _spender) constant returns (uint remaining);
14     event Transfer(address indexed _from, address indexed _to, uint _value);
15     event Approval(address indexed _owner, address indexed _spender, uint _value);
16 }
17 
18 // `owned` contracts allows us to specify an owner address
19 // which has admin right to this contract
20 contract owned {
21     address public owner;
22     event OwnershipTransferred(address indexed _from, address indexed _to);
23 
24     function owned() {
25         owner = msg.sender;
26     }
27 
28     modifier onlyOwner {
29         require(msg.sender == owner);
30         _;
31     }
32 
33     function transferOwnership(address newOwner) onlyOwner {
34         OwnershipTransferred(owner, newOwner);
35         owner = newOwner;
36     }
37 }
38 
39 // `halting` contracts allow us to stop activity on this contract,
40 // or even self-destruct if need be.
41 contract halting is owned {
42     bool public running = true;
43 
44     function start() onlyOwner {
45         running = true;
46     }
47 
48     function stop() onlyOwner {
49         running = false;
50     }
51 
52     function destruct() onlyOwner {
53         selfdestruct(owner);
54     }
55 
56     modifier halting {
57         assert(running);
58         _;
59     }
60 }
61 
62 // contract can buy or sell tokens for ETH
63 // prices are in amount of wei per batch of token units
64 contract TokenVault is owned, halting {
65 
66     address public asset;    // address of token
67     uint public sellPrice;   // contract sells lots at this price (in wei)
68     uint public units;       // lot size (token-wei)
69 
70     event MakerWithdrewAsset(uint tokens);
71     event MakerWithdrewEther(uint ethers);
72     event SoldTokens(uint tokens);
73 
74     // Constructor - only to be called by the TokenTraderFactory contract
75     function TokenVault (
76         address _asset,
77         uint _sellPrice,
78         uint _units
79     ) {
80         asset       = _asset;
81         sellPrice   = _sellPrice;
82         units       = _units;
83 
84         require(asset != 0);
85         require(sellPrice > 0);
86         require(units > 0);
87     }
88 
89     // Withdraw asset ERC20 Token
90     function makerWithdrawAsset(uint tokens) onlyOwner returns (bool ok) {
91         MakerWithdrewAsset(tokens);
92         return ERC20(asset).transfer(owner, tokens);
93     }
94 
95     // Withdraw all eth from this contract
96     function makerWithdrawEther() onlyOwner {
97         MakerWithdrewEther(this.balance);
98         return owner.transfer(this.balance);
99     }
100 
101     // Function to easily check this contracts balance
102     function getAssetBalance() constant returns (uint) {
103         return ERC20(asset).balanceOf(address(this));
104     }
105 
106     function min(uint a, uint b) private returns (uint) {
107         return a < b ? a : b;
108     }
109 
110     // Primary function; called with Ether sent to contract
111     function takerBuyAsset() payable halting {
112 
113         // Must request at least one asset
114         require(msg.value >= sellPrice);
115 
116         uint order    = msg.value / sellPrice;
117         uint can_sell = getAssetBalance() / units;
118         // start with no change
119         uint256 change = 0;
120         if (msg.value > (can_sell * sellPrice)) {
121             change  = msg.value - (can_sell * sellPrice);
122             order = can_sell;
123         }
124         if (change > 0) {
125             if (!msg.sender.send(change)) throw;
126         }
127         if (order > 0) {
128             if (!ERC20(asset).transfer(msg.sender, order * units)) throw;
129         }
130         SoldTokens(order);
131 
132     }
133 
134     // Ether is sent to the contract; can be either Maker or Taker
135     function () payable {
136         if (msg.sender == owner) {
137             // Allow owner to simply add eth to contract
138             return;
139         }
140         else {
141             // Otherwise, interpret as a buy request
142             takerBuyAsset();
143         }
144     }
145 }