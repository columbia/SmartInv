1 pragma solidity ^0.5.7;
2 
3 contract Ownable {
4     address public owner;
5     
6     event SetOwner(address _owner);
7 
8     modifier onlyOwner() {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     constructor() public {
14         emit SetOwner(msg.sender);
15         owner = msg.sender; 
16     }
17 
18     /**
19         @dev Transfers the ownership of the contract.
20 
21         @param _to Address of the new owner
22     */
23     function setOwner(address _to) external onlyOwner returns (bool) {
24         require(_to != address(0));
25         emit SetOwner(_to);
26         owner = _to;
27         return true;
28     } 
29 }
30 
31 interface Oracle {
32     function getRate(bytes32 currency, bytes calldata data) external returns (uint256, uint256);
33 }
34 
35 library SafeCast {
36     function toUint8(uint256 _v) internal pure returns (uint8) {
37         require(_v < 2 ** 8, "uint8 overflow");
38         return uint8(_v);
39     }
40 
41     function toUint40(uint256 _v) internal pure returns (uint40) {
42         require(_v < 2 ** 40, "uint40 overflow");
43         return uint40(_v);
44     }
45 
46     function toUint208(uint256 _v) internal pure returns (uint208) {
47         require(_v < 2 ** 208, "uint208 overflow");
48         return uint208(_v);
49     }
50 }
51 
52 contract SimpleOracle is Ownable {
53     using SafeCast for uint256;
54 
55     event DelegatedCall(
56         address requester,
57         address to
58     );
59 
60     event DeliveredRate(
61         address requester,
62         bytes32 currency,
63         uint256 deliverTimestamp,
64         uint256 rate,
65         uint256 decimals
66     );
67 
68     event UpdatedRate(
69         address delegate,
70         bytes32 currency,
71         uint256 timestamp,
72         uint256 rate,
73         uint256 decimals
74     );
75     
76     event SetExpirationTime(uint256 _time);
77     event SetUrl(string _url);
78     event SetFallback(address _fallback);
79     event SetDelegate(address _delegate);
80 
81     Oracle public fallback;
82     address public delegate;
83     uint256 public expiration = 6 hours;
84 
85     mapping(bytes32 => Rate) public rates;
86 
87     string private iurl;
88 
89     struct Rate {
90         uint8 decimals;
91         uint40 timestamp; 
92         uint208 value;
93     }
94 
95     modifier delegateOrOwner() {
96         require(msg.sender == delegate || msg.sender == owner, "Not authorized");
97         _;
98     }
99 
100     function url() public view returns (string memory) {
101         return iurl;
102     }
103 
104     function setExpirationTime(uint256 _time) external onlyOwner {
105         expiration = _time;
106         emit SetExpirationTime(_time);
107     }
108 
109     function setUrl(string calldata _url) external onlyOwner {
110         iurl = _url;
111         emit SetUrl(_url);
112     }
113 
114     function setFallback(Oracle _fallback) external onlyOwner {
115         fallback = _fallback;
116         emit SetFallback(address(_fallback));
117     }
118 
119     function setDelegate(address _delegate) external onlyOwner {
120         delegate = _delegate;
121         emit SetDelegate(_delegate);
122     }
123     
124     function updateRate(
125         bytes32 _currency,
126         uint256 _value,
127         uint256 _timestamp,
128         uint256 _decimals
129     ) external delegateOrOwner {
130         require(_timestamp <= block.timestamp, "Future rate");
131         require(_timestamp + expiration > block.timestamp, "Rate expired");
132 
133         rates[_currency] = Rate(
134             _decimals.toUint8(),
135             _timestamp.toUint40(),
136             _value.toUint208()
137         );
138 
139         emit UpdatedRate(
140             msg.sender,
141             _currency,
142             _timestamp,
143             _value,
144             _decimals
145         );
146     }
147 
148     function isExpired(uint256 timestamp) internal view returns (bool) {
149         return timestamp <= now - expiration;
150     }
151 
152     function getRate(bytes32 _currency, bytes calldata _data) external returns (uint256, uint256) {
153         if (address(fallback) != address(0)) {
154             emit DelegatedCall(msg.sender, address(fallback));
155             return fallback.getRate(_currency, _data);
156         }
157 
158         Rate memory rate = rates[_currency];
159         require(rate.timestamp + expiration > block.timestamp);
160         emit DeliveredRate(msg.sender, _currency, rate.timestamp, rate.value, rate.decimals);
161         return (rate.value, rate.decimals);
162     }
163 }