1 pragma solidity ^0.4.13;
2 
3 contract Latium {
4     string public constant name = "Latium";
5     string public constant symbol = "LAT";
6     uint8 public constant decimals = 16;
7     uint256 public constant totalSupply =
8         30000000 * 10 ** uint256(decimals);
9 
10     // owner of this contract
11     address public owner;
12 
13     // balances for each account
14     mapping (address => uint256) public balanceOf;
15 
16     // triggered when tokens are transferred
17     event Transfer(address indexed _from, address indexed _to, uint _value);
18 
19     // constructor
20     function Latium() {
21         owner = msg.sender;
22         balanceOf[owner] = totalSupply;
23     }
24 
25     // transfer the balance from sender's account to another one
26     function transfer(address _to, uint256 _value) {
27         // prevent transfer to 0x0 address
28         require(_to != 0x0);
29         // sender and recipient should be different
30         require(msg.sender != _to);
31         // check if the sender has enough coins
32         require(_value > 0 && balanceOf[msg.sender] >= _value);
33         // check for overflows
34         require(balanceOf[_to] + _value > balanceOf[_to]);
35         // subtract coins from sender's account
36         balanceOf[msg.sender] -= _value;
37         // add coins to recipient's account
38         balanceOf[_to] += _value;
39         // notify listeners about this transfer
40         Transfer(msg.sender, _to, _value);
41     }
42 }
43 
44 contract LatiumSeller {
45     address private constant _latiumAddress = 0xBb31037f997553BEc50510a635d231A35F8EC640;
46     Latium private constant _latium = Latium(_latiumAddress);
47 
48     // amount of Ether collected from buyers and not withdrawn yet
49     uint256 private _etherAmount = 0;
50 
51     // sale settings
52     uint256 private constant _tokenPrice = 10 finney; // 0.01 Ether
53     uint256 private _minimumPurchase =
54         10 * 10 ** uint256(_latium.decimals()); // 10 Latium
55 
56     // owner of this contract
57     address public owner;
58 
59     // constructor
60     function LatiumSeller() {
61         owner = msg.sender;
62     }
63 
64     function tokenPrice() constant returns(uint256 tokenPrice) {
65         return _tokenPrice;
66     }
67 
68     function minimumPurchase() constant returns(uint256 minimumPurchase) {
69         return _minimumPurchase;
70     }
71 
72     // function to get current Latium balance of this contract
73     function _tokensToSell() private returns (uint256 tokensToSell) {
74         return _latium.balanceOf(address(this));
75     }
76 
77     // function without name is the default function that is called
78     // whenever anyone sends funds to a contract
79     function () payable {
80         // we shouldn't sell tokens to their owner
81         require(msg.sender != owner && msg.sender != address(this));
82         // check if we have tokens to sell
83         uint256 tokensToSell = _tokensToSell();
84         require(tokensToSell > 0);
85         // calculate amount of tokens that can be bought
86         // with this amount of Ether
87         // NOTE: make multiplication first; otherwise we can lose
88         // fractional part after division
89         uint256 tokensToBuy =
90             msg.value * 10 ** uint256(_latium.decimals()) / _tokenPrice;
91         // check if user's purchase is above the minimum
92         require(tokensToBuy >= _minimumPurchase);
93         // check if we have enough tokens to sell
94         require(tokensToBuy <= tokensToSell);
95         _etherAmount += msg.value;
96         _latium.transfer(msg.sender, tokensToBuy);
97     }
98 
99     // functions with this modifier can only be executed by the owner
100     modifier onlyOwner() {
101         require(msg.sender == owner);
102         _;
103     }
104 
105     // function to withdraw Ether to owner's account
106     function withdrawEther(uint256 _amount) onlyOwner {
107         if (_amount == 0) {
108             // withdraw all available Ether
109             _amount = _etherAmount;
110         }
111         require(_amount > 0 && _etherAmount >= _amount);
112         _etherAmount -= _amount;
113         msg.sender.transfer(_amount);
114     }
115 
116     // function to withdraw Latium to owner's account
117     function withdrawLatium(uint256 _amount) onlyOwner {
118         uint256 availableLatium = _tokensToSell();
119         require(availableLatium > 0);
120         if (_amount == 0) {
121             // withdraw all available Latium
122             _amount = availableLatium;
123         }
124         require(availableLatium >= _amount);
125         _latium.transfer(msg.sender, _amount);
126     }
127 }