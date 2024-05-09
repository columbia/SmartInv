1 pragma solidity ^0.4.24;
2 
3 
4 // The contract for the locaToken instance
5 contract locaToken {
6     function transferFrom(address _from, address _to, uint _value) public returns (bool);
7     function allowance(address _owner, address _spender) public view returns (uint);
8 }
9 
10 // Safemath library  
11 library SafeMath {
12     function sub(uint _base, uint _value)
13     internal
14     pure
15     returns (uint) {
16         assert(_value <= _base);
17         return _base - _value;
18     }
19 
20     function add(uint _base, uint _value)
21     internal
22     pure
23     returns (uint _ret) {
24         _ret = _base + _value;
25         assert(_ret >= _base);
26     }
27 
28     function div(uint _base, uint _value)
29     internal
30     pure
31     returns (uint) {
32         assert(_value > 0 && (_base % _value) == 0);
33         return _base / _value;
34     }
35 
36     function mul(uint _base, uint _value)
37     internal
38     pure
39     returns (uint _ret) {
40         _ret = _base * _value;
41         assert(0 == _base || _ret / _base == _value);
42     }
43 }
44 
45 
46 
47 // The donation contract
48 
49 contract Donation  {
50     using SafeMath for uint;
51     // instance the locatoken
52     locaToken private token = locaToken(0xcDf9bAff52117711B33210AdE38f1180CFC003ed);
53     address  private owner;
54 
55     uint private _tokenGift;
56     // every donation is logged in the Blockchain
57     event Donated(address indexed buyer, uint tokens);
58      // Available tokens for donation
59     uint private _tokenDonation;
60   
61 
62     // constructor to set the contract owner
63     constructor() public {
64 
65         owner = msg.sender; 
66     }
67 
68 
69     modifier onlyOwner() {
70         require(msg.sender == owner);
71         _;
72     }
73     // Allow the donation to start
74     modifier allowStart() {
75         require(_tokenDonation == 0);
76         _;
77     }
78     // There have at least to be 25000000000 Loca tokens in balance to allow a valid donation
79     modifier allowDonation(){
80         require(_tokenDonation >= 25000000000);
81         _;
82     }
83     // Donation amount has to be between 0.02 and 0.03 ETH
84     // regardless the donation amount,  250 LOCAs will be send 
85     modifier validDonation {
86         require (msg.value >= 20000000000000000 && msg.value <= 30000000000000000);                                                                                        
87         _;
88     }
89 
90 
91     function startDonation() public onlyOwner allowStart returns (uint) {
92 
93         _tokenDonation = token.allowance(owner, address(this));
94     }
95 
96 
97     function DonateEther() public allowDonation validDonation payable {
98 
99        //  _tokensold = msg.value.mul(_convrate).div(Devider);
100         _tokenGift = 25000000000;
101         _tokenDonation = _tokenDonation.sub(_tokenGift);
102         
103         emit Donated(msg.sender, _tokenGift);
104 
105         token.transferFrom(owner, msg.sender, _tokenGift);
106 
107         
108 
109     }
110 
111     // Falsely send Ether will be reverted
112     function () public payable {
113         revert();
114     }
115 
116 
117     function TokenBalance () public view returns(uint){
118 
119         return _tokenDonation;
120 
121     }
122 
123     // Withdraw Ether from the contract
124     function getDonation(address _to) public onlyOwner {
125        
126         _to.transfer(address(this).balance);
127     
128     } 
129 
130     function CloseDonation() public onlyOwner {
131 
132         selfdestruct(owner);
133     }
134 
135 }