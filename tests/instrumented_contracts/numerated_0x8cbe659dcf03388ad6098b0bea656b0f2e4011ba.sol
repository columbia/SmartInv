1 /// @title Cryptocurrency  of the Ravensburg-Weingarten University of Applied Sciences ///(German: Hochschule Ravensburg-Weingarten) 
2 ///@author Walther,Dominik 
3 
4 pragma solidity ^0.4.13; contract owned { address public owner;
5   function owned() {
6       owner = msg.sender;
7   }
8   modifier onlyOwner {
9       require(msg.sender == owner);
10       _;
11   }
12   function transferOwnership(address newOwner) onlyOwner {
13       owner = newOwner;
14   }
15 }
16 /// receive other cryptocurrency
17 contract tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData); }
18 
19 /// the public variables of the HRWtoken
20 contract HRWtoken is owned { string public name; string public symbol; uint8 public decimals; uint256 public totalSupply; uint256 public sellPrice; uint256 public buyPrice;
21 ///@notice create an array with all adresses and associated balances of the cryptocurrency
22 
23   mapping (address => uint256) public balanceOf;
24   mapping (address => mapping (address => uint256)) public allowance;
25 
26  ///@notice generate a event on the blockchain to show transfer information 
27   event Transfer(address indexed from, address indexed to, uint256 value);
28 
29 ///@notice initialization of the contract and distribution of tokes to the creater
30   function HRWtoken(
31       uint256 initialSupply,
32       string tokenName,
33       uint8 decimalUnits,
34       string tokenSymbol,
35 address centralMinter
36       ) {
37 if(centralMinter != 0 ) owner = centralMinter;
38       balanceOf[msg.sender] = initialSupply;       
39       totalSupply = initialSupply;                        
40       name = tokenName;                                   
41       symbol = tokenSymbol;                               
42       decimals = decimalUnits;                            
43   }
44 
45   ///@notice only the contract can operate this internal funktion
46   function _transfer(address _from, address _to, uint _value) internal {
47       require (_to != 0x0);           
48       require (balanceOf[_from] >= _value);            
49       require (balanceOf[_to] + _value > balanceOf[_to]); 
50       balanceOf[_from] -= _value;                         
51       balanceOf[_to] += _value;                            
52       Transfer(_from, _to, _value);
53   }
54 
55   /// @notice transfer to account (_to) any value (_value)
56   /// @param _to The address of the reciver
57   /// @param _value value units from the cryptocurrency
58   function transfer(address _to, uint256 _value) {
59       _transfer(msg.sender, _to, _value);
60   }
61 
62   /// @notice to dend the tokens the sender need the allowance 
63   /// @param _from The address of the sender
64   /// @param _to The address of the recipient
65   /// @param _value value units to send
66   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
67       require (_value < allowance[_from][msg.sender]);     
68       allowance[_from][msg.sender] -= _value;
69       _transfer(_from, _to, _value);
70       return true;
71   }
72 
73   /// @notice the spender can only transfer the value units he own
74   /// @param _spender the address authorized to transfer
75   /// @param _value the max amount they can spend
76   function approve(address _spender, uint256 _value)
77       returns (bool success) {
78       allowance[msg.sender][_spender] = _value;
79       return true;
80   }
81 
82 /// @notice funktion contains approve with the addition to follow the contract ///about the allowance
83   /// @param _spender the address authorized to spend
84   /// @param _value the max amount they can spend
85   /// @param _extraData some extra information to send to the approved contract
86   function approveAndCall(address _spender, uint256 _value, bytes _extraData)
87       returns (bool success) {
88       tokenRecipient spender = tokenRecipient(_spender);
89       if (approve(_spender, _value)) {
90           spender.receiveApproval(msg.sender, _value, this, _extraData);
91           return true;
92       }
93   }        
94 /// @notice Create new token in addition to the initalsupply and send to target adress
95   /// @param target address to receive the tokens
96   /// @param mintedAmount ist the generated amount send to specified adress
97   function mintToken(address target, uint256 mintedAmount) onlyOwner {
98       balanceOf[target] += mintedAmount;
99       totalSupply += mintedAmount;
100       Transfer(0, this, mintedAmount);
101       Transfer(this, target, mintedAmount);
102   }
103   /// @notice participants of the Ethereum Network can buy or sell this token in ///exchange to Ether
104   /// @param newSellPrice price the users can sell to the contract
105   /// @param newBuyPrice price users can buy from the contract
106   function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
107       sellPrice = newSellPrice;
108       buyPrice = newBuyPrice;
109   }
110 
111 /// @notice The Ether send to the contract exchange by BuyPrice and send back  ///HRW Tokens
112   function buy() payable {
113       uint amount = msg.value / buyPrice;               
114       _transfer(this, msg.sender, amount);              
115   }
116 
117 /// @notice the HRWToken send to the contract and exchange by SellPrice and ///send ether back
118   /// @param amount HRW Token to sale
119   function sell(uint256 amount) {
120       require(this.balance >= amount * sellPrice);      
121       _transfer(msg.sender, this, amount);              
122       msg.sender.transfer(amount * sellPrice);          
123   }
124 }