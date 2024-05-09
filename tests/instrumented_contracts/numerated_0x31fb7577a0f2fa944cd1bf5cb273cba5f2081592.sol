1 pragma solidity ^0.4.18;
2 
3 contract RedEnvelope {
4 
5     struct EnvelopeType {
6         uint256 maxNumber;
7         uint256 feeRate;
8     }
9     
10     struct Envelope {
11         address maker;
12         address arbiter;
13         uint256 envelopeTypeId;
14         uint256 minValue;
15         uint256 remainingValue;
16         uint256 remainingNumber;
17         uint256 willExpireAfter;
18         bool random;
19         mapping(address => bool) tooks;
20     }
21 
22     struct Settings {
23         address arbiter;
24         uint256 minValue;
25     }
26 
27     event Made (
28         address indexed maker,
29         address indexed arbiter,
30         uint256 indexed envelopeId,
31         uint256 envelopeTypeId,
32         uint256 minValue,
33         uint256 total,
34         uint256 quantity,
35         uint256 willExpireAfter,
36         uint256 minedAt,
37         uint256 random
38     );
39 
40     event Took (
41         address indexed taker,
42         uint256 indexed envelopeId,
43         uint256 value,
44         uint256 minedAt
45     );
46 
47     event Redeemed(
48         address indexed maker,
49         uint256 indexed envelopeId,
50         uint256 value,
51         uint256 minedAt
52     );
53 
54     Settings public settings;
55     address public owner;
56     uint256 public balanceOfEnvelopes;
57     
58     mapping (address => uint256) public envelopeCounts;
59     mapping (uint256 => EnvelopeType) public envelopeTypes;
60     mapping (uint256 => Envelope) public envelopes;
61 
62     modifier onlyOwner {
63         require(owner == msg.sender);
64         _;
65     }
66 
67     function random() view private returns (uint256) {
68         // factor = ceil(2 ^ 256 / 100)
69         uint256 factor = 1157920892373161954235709850086879078532699846656405640394575840079131296399;
70         bytes32 blockHash = block.blockhash(block.number - 1);
71         return uint256(uint256(blockHash) / factor);
72     }
73 
74     function RedEnvelope() public {
75         settings = Settings(
76             msg.sender,
77             2000000000000000 // minValue = 0.002 ETH
78         );
79         owner = msg.sender;
80     }
81 
82     function setSettings(address _arbiter, uint256 _minValue) onlyOwner public {
83         settings.arbiter = _arbiter;
84         settings.minValue = _minValue;
85     }
86     
87     function setOwner(address _owner) onlyOwner public {
88         owner = _owner;
89     }
90 
91     function () payable public {}
92 
93     /*
94      * uint256 _envelopeTypeId
95      * uint256[2] _data
96      *  [0] - maxNumber
97      *  [1] - feeRate
98      */
99     function setEnvelopeType(uint256 _envelopeTypeId, uint256[2] _data) onlyOwner public {
100         envelopeTypes[_envelopeTypeId].maxNumber = _data[0];
101         envelopeTypes[_envelopeTypeId].feeRate = _data[1];
102     }
103 
104     /*
105      * uint256 _envelopeId
106      * uint256[3] _data
107      *  [0] - envelopeTypeId
108      *  [1] - quantity;
109      *  [2] - willExpireIn;
110      *  [3] - random
111      */
112     function make(uint256 _envelopeId, uint256[4] _data) payable external {
113         uint256 count = envelopeCounts[msg.sender] + 1;
114         if (uint256(keccak256(msg.sender, count)) != _envelopeId) { // 错误的envelopeId
115             revert();
116         }
117         EnvelopeType memory envelopeType = envelopeTypes[_data[0]];
118         if (envelopeType.maxNumber < _data[1]) { // quantity过大
119             revert();
120         }
121         uint256 total = ( msg.value * 1000 ) / ( envelopeType.feeRate + 1000 );
122         if (total / _data[1] < settings.minValue) { // value过小
123             revert();
124         }
125         Envelope memory envelope = Envelope(
126             msg.sender,                     // maker
127             settings.arbiter,               // arbiter
128             _data[0],                       // envelopeTypeId
129             settings.minValue,              // minValue
130             total,                          // remainingValue
131             _data[1],                       // remainingNumber
132             block.timestamp + _data[2],     // willExpireAfter
133             _data[3] > 0                    // random
134         );
135         
136         envelopes[_envelopeId] = envelope;
137         balanceOfEnvelopes += total;
138         envelopeCounts[msg.sender] = count;
139 
140         Made(
141             envelope.maker,
142             envelope.arbiter,
143             _envelopeId,
144             envelope.envelopeTypeId,
145             envelope.minValue,
146             envelope.remainingValue,
147             envelope.remainingNumber,
148             envelope.willExpireAfter,
149             block.timestamp,
150             envelope.random ? 1 : 0
151         );
152     }
153 
154     /*
155      * uint256 _envelopeId
156      * uint256[4] _data
157      *  [0] - willExpireAfter
158      *  [1] - v
159      *  [2] - r
160      *  [3] - s
161      */
162     function take(uint256 _envelopeId, uint256[4] _data) external {
163         // 验证红包
164         Envelope storage envelope = envelopes[_envelopeId];
165         if (envelope.willExpireAfter < block.timestamp) { // 红包过期
166             revert();
167         }
168         if (envelope.remainingNumber == 0) { // 抢完了
169             revert();
170         }
171         if (envelope.tooks[msg.sender]) { // 抢过了
172             revert();
173         }
174         // 验证arbiter的签名
175         if (_data[0] < block.timestamp) { // 签名过期
176             revert();
177         }
178         if (envelope.arbiter != ecrecover(keccak256(_envelopeId, _data[0], msg.sender), uint8(_data[1]), bytes32(_data[2]), bytes32(_data[3]))) { // 签名错误
179             revert();
180         }
181         
182         uint256 value = 0;
183         if (!envelope.random) {
184             value = envelope.remainingValue / envelope.remainingNumber;
185         } else {
186             if (envelope.remainingNumber == 1) {
187                 value = envelope.remainingValue;
188             } else {
189                 uint256 maxValue = envelope.remainingValue - (envelope.remainingNumber - 1) * envelope.minValue;
190                 uint256 avgValue = envelope.remainingValue / envelope.remainingNumber * 2;
191                 value = avgValue < maxValue ? avgValue * random() / 100 : maxValue * random() / 100;
192                 value = value < envelope.minValue ? envelope.minValue : value;
193             }
194         }
195 
196         envelope.remainingValue -= value;
197         envelope.remainingNumber -= 1;
198         envelope.tooks[msg.sender] = true;
199         balanceOfEnvelopes -= value;
200         msg.sender.transfer(value);
201 
202         Took(
203             msg.sender,
204             _envelopeId,
205             value,
206             block.timestamp
207         );
208     }
209 
210     /*
211      * uint256 _envelopeId
212      */
213     function redeem(uint256 _envelopeId) external {
214         Envelope storage envelope = envelopes[_envelopeId];
215         if (envelope.willExpireAfter >= block.timestamp) { // 尚未失效
216             revert();
217         }
218         if (envelope.remainingValue == 0) { // 没钱
219             revert();
220         }
221         if (envelope.maker != msg.sender) { // 不是maker
222             revert();
223         }
224 
225         uint256 value = envelope.remainingValue;
226         envelope.remainingValue = 0;
227         envelope.remainingNumber = 0;
228         balanceOfEnvelopes -= value;
229         msg.sender.transfer(value);
230 
231         Redeemed(
232             msg.sender,
233             _envelopeId,
234             value,
235             block.timestamp
236         );
237     }
238 
239     function getPaid(uint256 amount) onlyOwner external {
240         uint256 maxAmount = this.balance - balanceOfEnvelopes;
241         msg.sender.transfer(amount < maxAmount ? amount : maxAmount);
242     }
243 
244     function sayGoodBye() onlyOwner external {
245         selfdestruct(msg.sender);
246     }
247 }