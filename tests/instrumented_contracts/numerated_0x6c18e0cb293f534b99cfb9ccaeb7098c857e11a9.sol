1 pragma solidity ^0.4.25;
2 
3 contract Token {
4     function transfer(address receiver, uint amount) public;
5     function balanceOf(address receiver)public returns(uint);
6 }
7 
8 ///@title Axioms-Airdrops
9 ///@author  Lucasxhy & Kafcioo
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
22     ///@notice  Modifier to require a minimum amount fo ether for the function to add and airdrop
23     modifier minEth {
24         require(msg.value >= 2000); //Change this to amount of eth needed for gas fee in GWEI!
25         _;
26     }
27     ///@notice  Modifier that only allows the owner to execute a function
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32     ///@notice  Creates a structure for airdrops, which stores all the necessary information for users to look up the history effectively and directly from the smart contract.
33     struct Airdrop {
34         uint id;
35         uint tokenAmount;
36         string name;
37         uint countDown;
38         address distributor;
39         Token tokenSC;
40         mapping(address => address) uniqueAirdrop;
41     }
42 
43     ///@notice  Adds a new airdrop to the smart contract and starts the count down until it is distributed
44    function addNewAirdrop(
45    uint _tokenAmount,
46    string _name,
47    uint _countDown,
48    address  _smartContract
49    
50    )
51    public
52    minEth
53    payable
54    {
55        Token t = Token(_smartContract);
56        if(t.balanceOf(this)>=_tokenAmount){
57         uint lastIndex = airdrops.length++;
58         Airdrop storage airdrop = airdrops[lastIndex];
59         airdrop.id =idCounter;
60         airdrop.tokenAmount = _tokenAmount;
61         airdrop.name=_name;
62         airdrop.countDown=_countDown;
63         airdrop.distributor = msg.sender;
64         airdrop.tokenSC = Token(_smartContract);
65         airdrop.uniqueAirdrop[msg.sender]=_smartContract;
66         idCounter = airdrop.id+1;
67        }else revert('Air Drop not added, Please make sure you send your ERC20 tokens to the smart contract before adding new airdrop');
68    }
69 
70     ///@notice  Distirbutes a differen quantity of tokens to all the specified addresses.
71     ///@dev Distribution will only occur when a distribute function is called, and passed the correct parameters, it is not the smart contracts job to produce the addresses or determine the ammounts
72     ///@param index  The airdrop to distribute based in the the array in which is saved
73     ///@param _addrs The set of addresses in array form, to which the airdrop will be distributed
74     ///@param _vals  The set of values to be distributed to each address in array form
75     function distributeVariable(
76         uint index,
77         address[] _addrs,
78         uint[] _vals
79     )
80         public
81         onlyOwner
82     {
83         if(timeGone(index)==true) {
84             Airdrop memory airdrop = airdrops[index];
85             for(uint i = 0; i < _addrs.length; ++i) {
86                 airdrop.tokenSC.transfer(_addrs[i], _vals[i]);
87             }
88         } else revert("Distribution Failed: Count Down not gone yet");
89     }
90 
91     ///@notice  Distributes a constant quantity of tokens to all the specified addresses.
92     ///@dev Distribution will only occur when a distribute function is called, and passed the correct parameters, it is not the smart contracts job to produce the addresses or determine the ammount
93     ///@param index The airdrop token to withdraw based in the the array in which is saved
94     ///@param _amoutToEach  The amount to be withdrawn from the smart contract
95     function distributeFixed(
96         uint index,
97         address[] _addrs,
98         uint _amoutToEach
99     )
100         public
101         onlyOwner
102     {
103          if(timeGone(index)==true) {
104             Airdrop memory airdrop = airdrops[index];
105             for(uint i = 0; i < _addrs.length; ++i) {
106                 airdrop.tokenSC.transfer(_addrs[i], _amoutToEach);
107             }
108         } else revert("Distribution Failed: Coun Down not gone yet");
109     }
110 
111 // Refound tokens back to the to airdrop creator 
112     function refoundTokens(
113         uint index,
114         address receiver,
115         address sc
116     )
117         public
118         onlyOwner
119     {   
120         
121         Airdrop memory airdrop = airdrops[index];
122         if(cheackIfAirDropIsUnique(index,receiver,sc)==true){
123         airdrop.tokenSC.transfer(airdrop.distributor,airdrop.tokenAmount);
124         }else revert();
125         
126     }
127     
128     // Refound eth left over from Distribution back to the airdrop creator 
129       function refoundLeftOverEth (
130     uint index,
131     uint amount,
132     address receiver,
133     address sc
134     )
135       public 
136       onlyOwner
137    {
138        Airdrop memory airdrop = airdrops[index];
139        if(cheackIfAirDropIsUnique(index,receiver,sc)==true){
140       airdrop.distributor.transfer(amount);
141        }else revert();
142    }
143     
144     ///@notice  Determines whether an aidrop is due to be distributed or not.
145     ///@dev Distribution will only occur when a distribute function is called, and passed the correct parameters, it is not the smart contracts job to produce the addresses or determine the ammount
146    function timeGone(uint index) private view returns(bool){
147       Airdrop memory airdrop = airdrops[index];
148       uint timenow=now;
149       if ( airdrop.countDown <timenow){
150           return (true);
151       }else return (false);
152     }
153     
154     function cheackIfAirDropIsUnique(uint index, address receiver, address sc) private view returns(bool){
155         Airdrop storage airdrop = airdrops[index];
156         if(airdrop.uniqueAirdrop[receiver]==sc){
157             return true;
158         }else return false;
159     
160     }
161     function transferOwnership(address _newOwner) public onlyOwner(){
162         require(_newOwner != address(0));
163         owner = _newOwner;
164     }
165 }