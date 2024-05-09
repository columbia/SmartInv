1 pragma solidity ^0.4.25;
2 
3 contract Token {
4     function transfer(address receiver, uint amount) public;
5     function balanceOf(address receiver)public returns(uint);
6 }
7 
8 ///@title Axioms-Airdrops
9 ///@author Lucasxhy & Kafcioo
10 
11 contract Axioms {
12     Airdrop [] public airdrops;
13     address owner;
14     uint idCounter;
15     
16     ///@notice  Set the creator of the smart contract to be its sole owner
17     constructor () public {
18         owner = msg.sender;
19     }
20     
21     
22     ///@notice  Modifier to require a minimum amount of ether for the function to launch
23     modifier minEth {
24         require(msg.value >= 2000); 
25         _;
26     }
27 
28     ///@notice  Modifier that only allows the owner to execute a function
29     modifier onlyOwner() {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     ///@notice  Creates a structure for airdrops, which stores all the necessary information for users to look up the history effectively and directly from the smart contract
35     struct Airdrop {
36         uint id;
37         uint tokenAmount;
38         string name;
39         uint countDown;
40         address distributor;
41         Token tokenSC;
42         mapping(address => address) uniqueAirdrop;
43     }
44 
45     ///@notice  Adds a new airdrop to the smart contract and starts the count down until it is distributed
46    function addNewAirdrop(
47      uint _tokenAmount,
48      string _name,
49      uint _countDown,
50      address  _smartContract
51    
52    )
53      public
54      minEth
55      payable
56    {
57        Token t = Token(_smartContract);
58        if(t.balanceOf(this)>=_tokenAmount){
59         uint lastIndex = airdrops.length++;
60         Airdrop storage airdrop = airdrops[lastIndex];
61         airdrop.id =idCounter;
62         airdrop.tokenAmount = _tokenAmount;
63         airdrop.name=_name;
64         airdrop.countDown=_countDown;
65         airdrop.distributor = msg.sender;
66         airdrop.tokenSC = Token(_smartContract);
67         airdrop.uniqueAirdrop[msg.sender]=_smartContract;
68         idCounter = airdrop.id+1;
69        }else revert('Air Drop not added, Please make sure you send your ERC20 tokens to the smart contract before adding new airdrop');
70    }
71 
72     ///@notice  Distirbutes a different quantity of tokens to all the specified addresses
73     ///@dev Distribution will only occur when a distribute function is called and passed the correct parameters. It is not the smart contract's job to produce the addresses or determine the amounts
74     ///@param index  The airdrop to distribute based in the the array in which is saved
75     ///@param _addrs The set of addresses in array form, to which the airdrop will be distributed
76     ///@param _vals  The set of values to be distributed to each address in array form
77     function distributeVariable(
78         uint index,
79         address[] _addrs,
80         uint[] _vals
81     )
82         public
83         onlyOwner
84     {
85         if(timeGone(index)==true) {
86             Airdrop memory airdrop = airdrops[index];
87             for(uint i = 0; i < _addrs.length; ++i) {
88                 airdrop.tokenSC.transfer(_addrs[i], _vals[i]);
89             }
90         } else revert("Distribution Failed: Countdown not finished yet");
91     }
92 
93     ///@notice  Distirbutes a constant quantity of tokens to all the specified addresses
94     ///@dev Distribution will only occur when a distribute function is called and passed the correct parameters. It is not the smart contract's job to produce the addresses or determine the amounts
95     ///@param index  The airdrop to distribute based in the the array in which is saved
96     ///@param _addrs The set of addresses in array form, to which the airdrop will be distributed
97     ///@param _amoutToEach  The value to be distributed to each address in array form
98     function distributeFixed(
99         uint index,
100         address[] _addrs,
101         uint _amoutToEach
102     )
103         public
104         onlyOwner
105     {
106          if(timeGone(index)==true) {
107             Airdrop memory airdrop = airdrops[index];
108             for(uint i = 0; i < _addrs.length; ++i) {
109                 airdrop.tokenSC.transfer(_addrs[i], _amoutToEach);
110             }
111         } else revert("Distribution Failed: Countdown not finished yet");
112     }
113 
114     ///@notice Refund tokens back to the to airdrop creator 
115     function refoundTokens(
116         uint index,
117         address receiver,
118         address sc
119     )
120         public
121         onlyOwner
122     {   
123         
124         Airdrop memory airdrop = airdrops[index];
125         if(isAirDropUnique(index,receiver,sc)==true){
126         airdrop.tokenSC.transfer(airdrop.distributor,airdrop.tokenAmount);
127         }else revert();
128         
129     }
130     
131     ///@notice Refund eth left over from Distribution back to the airdrop creator 
132     function refundLeftOverEth (
133         uint index,
134         uint amount,
135         address reciever,
136         address sc
137     )
138         public 
139         onlyOwner
140     {
141          Airdrop memory airdrop = airdrops[index];
142          if(isAirDropUnique(index,reciever,sc)==true){
143         airdrop.distributor.transfer(amount);
144          }else revert();
145     }
146       
147     ///@notice  Determines whether an aidrop is due to be distributed or not
148     ///@dev Distribution will only occur when a distribute function is called and passed the correct parameters. It is not the smart contract's job to produce the addresses or determine the amounts
149     function timeGone(uint index) private view returns(bool){
150         Airdrop memory airdrop = airdrops[index];
151         uint timenow=now;
152         if ( airdrop.countDown <timenow){
153             return (true);
154         }else return (false);
155       }
156       
157     ///@notice  Determines whether an aidrop unique
158     function isAirDropUnique(uint index, address receiver, address sc) private view returns(bool){
159         Airdrop storage airdrop = airdrops[index];
160         if(airdrop.uniqueAirdrop[receiver]==sc){
161             return true;
162         }else return false; 
163     }
164 
165     ///@notice Transfer smartContract ownership
166     function transferOwnership(address _newOwner) public onlyOwner(){
167         require(_newOwner != address(0));
168         owner = _newOwner;
169     }
170 }