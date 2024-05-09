1 pragma solidity ^0.4.25;
2 
3 contract Token {
4     function transfer(address receiver, uint amount) public;
5     function balanceOf(address receiver)public returns(uint);
6 }
7 
8 ///@title Axioms-Airdrops
9 ///@author  Lucasxhy & Kafcioo
10 contract Axioms {
11     Airdrop [] public airdrops;
12     address owner;
13     uint idCounter;
14     
15     ///@notice  Set the creator of the smart contract to be its sole owner
16     constructor () public {
17         owner = msg.sender;
18     }
19     
20     
21     ///@notice  Modifier to require a minimum amount fo ether for the function to add and airdrop
22     modifier minEth {
23         require(msg.value >= 2000); //Change this to amount of eth we want in GWEI!
24         _;
25     }
26     ///@notice  Modifier that only allows the owner to execute a function
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31     ///@notice  Creates a structure for airdrops, which stores all the necessary information for users to look up the history effectively and directly from the smart contract.
32     struct Airdrop {
33         uint id;
34         uint tokenAmount;
35         string name;
36         uint countDown;
37         address distributor;
38         Token tokenSC;
39     }
40 
41     ///@notice  Adds a new airdrop to the smart contract and starts the count down until it is distributed
42    function addNewAirdrop(
43    uint _tokenAmount,
44    string _name,
45    uint _countDown,
46    address  _smartContract
47    
48    )
49    public
50    minEth
51    payable
52    {
53        Token t = Token(_smartContract);
54        if(t.balanceOf(this)>=_tokenAmount)
55         uint lastIndex = airdrops.length++;
56         Airdrop storage airdrop = airdrops[lastIndex];
57         airdrop.id =idCounter;
58         airdrop.tokenAmount = _tokenAmount;
59         airdrop.name=_name;
60         airdrop.countDown=_countDown;
61         airdrop.distributor = msg.sender;
62         airdrop.tokenSC = Token(_smartContract);
63         idCounter = airdrop.id+1;
64    }
65 
66     ///@notice  Distirbutes a differen quantity of tokens to all the specified addresses.
67     ///@dev Distribution will only occur when a distribute function is called, and passed the correct parameters, it is not the smart contracts job to produce the addresses or determine the ammounts
68     ///@param index  The airdrop to distribute based in the the array in which is saved
69     ///@param _addrs The set of addresses in array form, to which the airdrop will be distributed
70     ///@param _vals  The set of values to be distributed to each address in array form
71     function distributeVariable(
72         uint index,
73         address[] _addrs,
74         uint[] _vals
75     )
76         public
77         onlyOwner
78     {
79         if(timeGone(index)==true && getTokensBalance(index)>= airdrop.tokenAmount) {
80             Airdrop memory airdrop = airdrops[index];
81             for(uint i = 0; i < _addrs.length; ++i) {
82                 airdrop.tokenSC.transfer(_addrs[i], _vals[i]);
83             }
84         } else revert("Airdrop was NOT added");
85     }
86 
87     ///@notice  Distributes a constant quantity of tokens to all the specified addresses.
88     ///@dev Distribution will only occur when a distribute function is called, and passed the correct parameters, it is not the smart contracts job to produce the addresses or determine the ammount
89     ///@param index The airdrop token to withdraw based in the the array in which is saved
90     ///@param _amoutToEach  The amount to be withdrawn from the smart contract
91     function distributeFixed(
92         uint index,
93         address[] _addrs,
94         uint _amoutToEach
95     )
96         public
97         onlyOwner
98     {
99          if(timeGone(index)==true && getTokensBalance(index)>= airdrop.tokenAmount) {
100             Airdrop memory airdrop = airdrops[index];
101             for(uint i = 0; i < _addrs.length; ++i) {
102                 airdrop.tokenSC.transfer(_addrs[i], _amoutToEach);
103             }
104         } else revert("Airdrop was NOT added");
105     }
106     
107     ///@notice  Distirbutes a constant quantity of tokens to all the specified addresses.
108     ///@dev Distribution will only occur when a distribute function is called, and passed the correct parameters, it is not the smart contracts job to produce the addresses or determine the ammount
109     ///@param index  The airdrop to distribute based in the the array in which is saved
110     ///@param _amount  The value to be distributed to each address in array form.
111     function withdrawTokens(
112         uint index,
113         uint _amount
114     )
115         public
116         onlyOwner
117     {
118         Airdrop memory airdrop = airdrops[index];
119         airdrop.tokenSC.transfer(owner,_amount);
120     }
121     
122     ///@notice  Determines whether an aidrop is due to be distributed or not.
123     ///@dev Distribution will only occur when a distribute function is called, and passed the correct parameters, it is not the smart contracts job to produce the addresses or determine the ammount
124    function timeGone(uint index) private view returns(bool){
125       Airdrop memory airdrop = airdrops[index];
126       uint timenow=now;
127       if ( airdrop.countDown <timenow){
128           return (true);
129       }else return (false);
130     }
131   
132     ///@notice  Get the balance of a specific token within the smart contracts
133    function getTokensBalance(uint index) private view returns(uint) {
134         Airdrop memory airdrop = airdrops[index];
135         Token t = Token(airdrop.tokenSC);
136         return (t.balanceOf(this));
137     }
138   
139   function withdrawLeftOverEth (
140       uint amount,
141       address receiver
142     )
143       public 
144       onlyOwner
145    {
146       receiver.transfer(amount);
147    }
148 }