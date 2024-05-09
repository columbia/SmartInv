1 pragma solidity ^0.4.20;
2 
3 contract owned {
4     address public owner;
5     address public tokenContract;
6     constructor() public{
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     modifier onlyOwnerAndtokenContract {
16         require(msg.sender == owner || msg.sender == tokenContract);
17         _;
18     }
19 
20 
21     function transferOwnership(address newOwner) onlyOwner public {
22         if (newOwner != address(0)) {
23             owner = newOwner;
24         }
25     }
26     
27     function transfertokenContract(address newOwner) onlyOwner public {
28         if (newOwner != address(0)) {
29             tokenContract = newOwner;
30         }
31     }
32 }
33 
34 contract DataContract is owned {
35     struct Good {
36         bytes32 preset;
37         uint price;
38         uint time;
39     }
40 
41     mapping (bytes32 => Good) public goods;
42 
43     function setGood(bytes32 _preset, uint _price) onlyOwnerAndtokenContract external {
44         goods[_preset] = Good({preset: _preset, price: _price, time: now});
45     }
46     
47     function getGoodPreset(bytes32 _preset) view public returns (bytes32) {
48         return goods[_preset].preset;
49     }
50     
51     function getGoodPrice(bytes32 _preset) view public returns (uint) {
52         return goods[_preset].price;
53     }
54 
55     mapping (bytes32 => address) public decisionOf;
56 
57     function setDecision(bytes32 _preset, address _address) onlyOwnerAndtokenContract external {
58         decisionOf[_preset] = _address;
59     }
60 
61     function getDecision(bytes32 _preset) view public returns (address) {
62         return decisionOf[_preset];
63     }
64 }
65 
66 
67 contract Token is owned {
68 
69     DataContract DC;
70 
71     constructor(address _dataContractAddr) public{
72         DC = DataContract(_dataContractAddr);
73     }
74     
75     uint _seed = now;
76 
77     struct Good {
78         bytes32 preset;
79         uint price;
80         uint time;
81     }
82 
83     // controll
84 
85     event Decision(uint result, address finalAddress, address[] buyers, uint[] amounts);
86 
87     function _random() internal returns (uint randomNumber) {
88         _seed = uint(keccak256(keccak256(block.blockhash(block.number-100))));
89         return _seed ;
90     }
91 
92     function _stringToBytes32(string memory _source) internal pure returns (bytes32 result) {
93         bytes memory tempEmptyStringTest = bytes(_source);
94         if (tempEmptyStringTest.length == 0) {
95             return 0x0;
96         }
97         assembly {
98             result := mload(add(_source, 32))
99         }
100     }
101 
102     // get decision result address
103     function _getFinalAddress(uint[] _amounts, address[] _buyers, uint result) internal pure returns (address finalAddress) {
104         uint congest = 0;
105         address _finalAddress = address(0);
106         for (uint j = 0; j < _amounts.length; j++) {
107             congest += _amounts[j];
108             if (result <= congest && _finalAddress == address(0)) {
109                 _finalAddress = _buyers[j];
110             }
111         }
112         return _finalAddress;
113     }
114 
115     function postTrade(bytes32 _preset, uint _price) onlyOwner public {
116         require(DC.getGoodPreset(_preset) == "");
117         DC.setGood(_preset, _price);
118     }
119 
120     function decision(bytes32 _preset, string _presetSrc, address[] _buyers, uint[] _amounts) onlyOwner public payable{
121         
122         // execute it only once
123         require(DC.getDecision(_preset) == address(0));
124 
125         // preset authenticity
126         require(sha256(_presetSrc) == DC.getGoodPreset(_preset));
127 
128         // address added, parameter 1
129         uint160 allAddress;
130         for (uint i = 0; i < _buyers.length; i++) {
131             allAddress += uint160(_buyers[i]);
132         }
133         
134         // random, parameter 2
135         uint random = _random();
136 
137         uint goodPrice = DC.getGoodPrice(_preset);
138 
139         // preset is parameter 3, add and take the remainder
140         uint result = uint(uint(_stringToBytes32(_presetSrc)) + allAddress + random) % goodPrice;
141 
142         address finalAddress = _getFinalAddress(_amounts, _buyers, result);
143         // save decision result
144         DC.setDecision(_preset, finalAddress);
145         Decision(result, finalAddress, _buyers, _amounts);
146     }
147 }