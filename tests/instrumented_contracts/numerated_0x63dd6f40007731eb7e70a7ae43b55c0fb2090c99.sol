1 /*
2 Thank you ConsenSys, this contract originated from:
3 https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/Standard_Token.sol
4 Which is itself based on the Ethereum standardized contract APIs:
5 https://github.com/ethereum/wiki/wiki/Standardized_Contract_APIs
6 */
7 
8 /// @title Standard Token Contract.
9 contract TokenInterface {
10     mapping (address => uint256) balances;
11     mapping (address => mapping (address => uint256)) allowed;
12     uint256 public totalSupply;
13     function balanceOf(address _owner) constant returns (uint256 balance);
14     function transfer(address _to, uint256 _amount) returns (bool success);
15     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success);
16     function approve(address _spender, uint256 _amount) returns (bool success);
17     function allowance(
18         address _owner,
19         address _spender
20     ) constant returns (uint256 remaining);
21     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
22     event Approval(
23         address indexed _owner,
24         address indexed _spender,
25         uint256 _amount
26     );
27 }
28 
29 
30 // compiled using https://ethereum.github.io/browser-solidity/#version=soljson-v0.3.2-2016-05-20-e3c5418.js&optimize=true
31 contract Token_Offer {
32   address public tokenHolder;
33   address public owner;
34   TokenInterface public tokenContract;
35   uint16 public price;  // price in ETH per 100000 tokens. Price 2250 means 2.25 ETH per 100 tokens
36   uint public tokensPurchasedTotal;
37   uint public ethCostTotal;
38 
39   event TokensPurchased(address buyer, uint16 price, uint tokensPurchased, uint ethCost, uint ethSent, uint ethReturned, uint tokenSupplyLeft);
40   event Log(string msg, uint val);
41 
42   modifier onlyOwnerAllowed() {if (tx.origin != owner) throw; _}
43 
44   function Token_Offer(address _tokenContract, address _tokenHolder, uint16 _price)  {
45     owner = tx.origin;
46     tokenContract = TokenInterface(_tokenContract);
47     tokenHolder = _tokenHolder;
48     price = _price;
49   }
50 
51   function tokenSupply() constant returns (uint tokens) {
52     uint allowance = tokenContract.allowance(tokenHolder, address(this));
53     uint balance = tokenContract.balanceOf(tokenHolder);
54     if (allowance < balance) return allowance;
55     else return balance;
56   }
57 
58   function () {
59     buyTokens(price);
60   }
61 
62   function buyTokens() {
63     buyTokens(price);
64   }
65 
66   /// @notice DON'T BUY FROM EXCHANGE! Only buy from normal account in your full control (private key).
67   /// @param _bidPrice Price in ETH per 100000 tokens. _bidPrice 2250 means 2.25 ETH per 100 tokens.
68   function buyTokens(uint16 _bidPrice) {
69     if (tx.origin != msg.sender) { // buyer should be able to handle TheDAO (vote, transfer, ...)
70       if (!msg.sender.send(msg.value)) throw; // send ETH back to sender's contract
71       Log("Please send from a normal account, not contract/multisig", 0);
72       return;
73     }
74     if (price == 0) {
75       if (!tx.origin.send(msg.value)) throw; // send ETH back
76       Log("Contract disabled", 0);
77       return;
78     }
79     if (_bidPrice < price) {
80       if (!tx.origin.send(msg.value)) throw; // send ETH back
81       Log("Bid too low, price is:", price);
82       return;
83     }
84     if (msg.value == 0) {
85       Log("No ether received", 0);
86       return;
87     }
88     uint _tokenSupply = tokenSupply();
89     if (_tokenSupply == 0) {
90       if (!tx.origin.send(msg.value)) throw; // send ETH back
91       Log("No tokens available, please try later", 0);
92       return;
93     }
94 
95     uint _tokensToPurchase = (msg.value * 1000) / price;
96 
97     if (_tokensToPurchase <= _tokenSupply) { // contract has enough tokens to complete order
98       if (!tokenContract.transferFrom(tokenHolder, tx.origin, _tokensToPurchase)) // send tokens
99         throw;
100       tokensPurchasedTotal += _tokensToPurchase;
101       ethCostTotal += msg.value;
102       TokensPurchased(tx.origin, price, _tokensToPurchase, msg.value, msg.value, 0, _tokenSupply-_tokensToPurchase);
103 
104     } else { // contract low on tokens, partial order execution
105       uint _supplyInEth = (_tokenSupply * price) / 1000;
106       if (!tx.origin.send(msg.value-_supplyInEth)) // return extra eth
107         throw;
108       if (!tokenContract.transferFrom(tokenHolder, tx.origin, _tokenSupply)) // send tokens
109         throw;
110       tokensPurchasedTotal += _tokenSupply;
111       ethCostTotal += _supplyInEth;
112       TokensPurchased(tx.origin, price, _tokenSupply, _supplyInEth, msg.value, msg.value-_supplyInEth, 0);
113     }
114   }
115 
116   /* == functions below are for owner only == */
117   function setPrice(uint16 _price) onlyOwnerAllowed {
118     price = _price;
119     Log("Price changed:", price); // watch the contract to see updates
120   }
121   function tokenSupplyChanged() onlyOwnerAllowed {
122     Log("Supply changed, new supply:", tokenSupply()); // watch the contract to see updates
123   }
124   function setTokenHolder(address _tokenHolder) onlyOwnerAllowed {
125     tokenHolder = _tokenHolder;
126   }
127   function setOwner(address _owner) onlyOwnerAllowed {
128     owner = _owner;
129   }
130   function transferETH(address _to, uint _amount) onlyOwnerAllowed {
131     if (_amount > address(this).balance) {
132       _amount = address(this).balance;
133     }
134     _to.send(_amount);
135   }
136 }