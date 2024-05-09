1 pragma solidity ^0.4.24;
2 
3 contract ConnectCapacity {
4 
5     address private controllerSystem;
6 
7     // struct AdaptionOrder
8     struct AdaptionOrder {
9         address vglNb;
10         int256 cot;
11         int256 pct;
12         int256 tct;
13         int256 ict;
14     }
15 
16     // map address -> tokenclassId -> balance
17     mapping(address => mapping(string => int256)) private capacityBalance;
18 
19     // map rc -> timestamp -> struct(AdaptionOrder)
20     mapping(address => mapping( uint256 => AdaptionOrder)) private adaptionMap;
21 
22     event Transfer (address indexed from, address indexed to, string classId, int256 value, int256 balanceAfterTx);
23 
24     event Changed (address indexed rc, int256 tctValue, int256 ictValue,
25     int256 balanceOfTCTGiveAfterTx, int256 balanceOfICTGiveAfterTx, int256 balanceOfCOTAfterTx);
26  
27     event AdaptionRequest (address indexed from, uint256 indexed time, int256 value);
28 
29     event AdaptionRelease (address indexed vglNbAddress, address indexed rcAddress, uint256 time);
30 
31     modifier onlySystem() {
32         require(msg.sender == controllerSystem, "only System can invoke");
33         _;
34     }
35 
36     constructor() public {
37         controllerSystem = msg.sender;
38     }
39 
40     function transfer(address _from, address _to, string memory _classId, int256 _value) public onlySystem() {
41         require(_value >= 0, "Negative amount");
42         if (_value != 0) {
43             capacityBalance[_to][_classId] = capacityBalance[_to][_classId] + _value;
44             capacityBalance[_from][_classId] = capacityBalance[_from][_classId] - _value;
45         }
46         int256 balanceAfterTx = capacityBalance[_from][_classId];
47         emit Transfer(_from, _to, _classId, _value, balanceAfterTx);
48     }
49 
50     function interchange(address _from, address _to, int256 _valueTCT, int256 _valueICT) public onlySystem() {
51 
52         require(_valueTCT >= 0, "TCT can only be reduced");
53         require(capacityBalance[_from]["TCT"] >= _valueTCT, "the TCT value is bigger than the current Balance");
54         require(_valueICT >= 0 || _valueTCT >= -1 * _valueICT, "the increased ICT value is bigger than the given TCT");
55         capacityBalance[_from]["TCT"] = capacityBalance[_from]["TCT"] - _valueTCT;
56         capacityBalance[_from]["ICT"] = capacityBalance[_from]["ICT"] - _valueICT;
57         capacityBalance[_from]["COT"] = capacityBalance[_from]["COT"] + _valueTCT + _valueICT;
58 
59         capacityBalance[_to]["TCT"] = capacityBalance[_to]["TCT"] + _valueTCT;
60         capacityBalance[_to]["ICT"] = capacityBalance[_to]["ICT"] + _valueICT;
61         capacityBalance[_to]["COT"] = capacityBalance[_to]["COT"] - _valueTCT - _valueICT;
62 
63         int256 balanceOfTCTGiveAfterTx = capacityBalance[_from]["TCT"];
64         int256 balanceOfICTGiveAfterTx = capacityBalance[_from]["ICT"];
65         int256 balanceOfCOTAfterTx = capacityBalance[_from]["COT"];
66         emit Changed(_from, _valueTCT, _valueICT, balanceOfTCTGiveAfterTx, balanceOfICTGiveAfterTx, balanceOfCOTAfterTx);
67     }
68 
69     function createAdaptionRequest(address _rc, address _vglNb, int256 _value, uint256 _timeOfChange) public onlySystem() {
70         AdaptionOrder memory adaption = adaptionMap[_rc][_timeOfChange];
71         // if Adaption already exist the value of COT will be replaced with the new one to allow Update.
72         adaptionMap[_rc][_timeOfChange] = AdaptionOrder(_vglNb, _value, adaption.pct, adaption.tct, adaption.ict);
73         emit AdaptionRequest(_rc, _timeOfChange, _value);
74     }
75 
76     function changeAdaptionRequest(address _rc, address _vglNb, int256 _value, uint256 _timeOfChange,
77         uint256 _oldTimeOfChange) public onlySystem() {
78         delete adaptionMap[_rc][_oldTimeOfChange];
79         createAdaptionRequest(_rc, _vglNb, _value, _timeOfChange);
80 
81     }
82 
83     function confirmAdaptionRequest(address _rc, int256 _valueOfPCT, int256 _valueOfTCT, int256 _valueOfICT, uint256 timeOfChange)
84       public onlySystem() {
85         AdaptionOrder storage adaption = adaptionMap[_rc][timeOfChange];
86         require(adaption.vglNb != address(0), "there is no Adaption");
87         adaption.pct = _valueOfPCT;
88         adaption.tct = _valueOfTCT;
89         adaption.ict = _valueOfICT;
90     }
91 
92     function releaseAdaption(address _rc, uint256 timeOfChange) public onlySystem() {
93         AdaptionOrder storage adaption = adaptionMap[_rc][timeOfChange];
94         require(adaption.vglNb != address(0), "there is no Adaption");
95         if (adaption.cot >= 0) {
96             transfer(_rc, adaption.vglNb, "COT", adaption.cot);
97         } else {
98             transfer(adaption.vglNb, _rc, "COT", -1 * adaption.cot);
99         }
100         if (adaption.pct >= 0) {
101             transfer(adaption.vglNb, _rc, "PCT", adaption.pct);
102         } else {
103             transfer(_rc, adaption.vglNb, "PCT", -1 * adaption.pct);
104         }
105         if (adaption.tct >= 0) {
106             transfer(adaption.vglNb, _rc, "TCT", adaption.tct);
107         } else {
108             transfer(_rc, adaption.vglNb, "TCT", -1 * adaption.tct);
109         }
110         if (adaption.ict >= 0) {
111             transfer(adaption.vglNb, _rc, "ICT", adaption.ict);
112         } else {
113             transfer(_rc, adaption.vglNb, "ICT", -1 * adaption.ict);
114         }
115 
116         emit AdaptionRelease(adaption.vglNb, _rc, timeOfChange);
117         delete adaptionMap[_rc][timeOfChange];
118     }
119 
120     function balanceOf(address _address, string memory _classId) public view returns (int256) {
121         return capacityBalance[_address][_classId];
122     }
123 
124     function getAdaptionValues(address _rc, uint256 timeOfChange) public view returns (int256, int256, int256, int256) {
125         AdaptionOrder storage adaption = adaptionMap[_rc][timeOfChange];
126         return (adaption.cot, adaption.pct, adaption.tct, adaption.ict);
127     }
128 
129     function getTotalBalance(address _address) public view returns(int256 currentBalance) {
130         int256 balanceForCOT = balanceOf(_address, "COT");
131         int256 balanceForPCT = balanceOf(_address, "PCT");
132         int256 balanceForTCT = balanceOf(_address, "TCT");
133         int256 balanceForICT = balanceOf(_address, "ICT");
134         currentBalance = balanceForCOT + balanceForPCT + balanceForTCT + balanceForICT;
135     }
136 
137     function () external payable {
138         revert("not allowed function");
139     }
140 
141 }