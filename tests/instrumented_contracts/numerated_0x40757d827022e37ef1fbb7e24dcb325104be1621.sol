1 /*
2     ___            _       ___  _                          
3     | .\ ___  _ _ <_> ___ | __><_>._ _  ___ ._ _  ___  ___ 
4     |  _// ._>| '_>| ||___|| _> | || ' |<_> || ' |/ | '/ ._>
5     |_|  \___.|_|  |_|     |_|  |_||_|_|<___||_|_|\_|_.\___.
6     
7 * PeriFinance: ExternalRateAggregator.sol
8 *
9 * Latest source (may be newer): https://github.com/perifinance/peri-finance/blob/master/contracts/ExternalRateAggregator.sol
10 * Docs: Will be added in the future. 
11 * https://docs.peri.finance/contracts/source/contracts/ExternalRateAggregator
12 *
13 * Contract Dependencies: 
14 *	- Owned
15 * Libraries: (none)
16 *
17 * MIT License
18 * ===========
19 *
20 * Copyright (c) 2021 PeriFinance
21 *
22 * Permission is hereby granted, free of charge, to any person obtaining a copy
23 * of this software and associated documentation files (the "Software"), to deal
24 * in the Software without restriction, including without limitation the rights
25 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
26 * copies of the Software, and to permit persons to whom the Software is
27 * furnished to do so, subject to the following conditions:
28 *
29 * The above copyright notice and this permission notice shall be included in all
30 * copies or substantial portions of the Software.
31 *
32 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
33 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
34 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
35 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
36 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
37 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
38 */
39 
40 
41 
42 pragma solidity 0.5.16;
43 
44 // https://docs.peri.finance/contracts/source/contracts/owned
45 contract Owned {
46     address public owner;
47     address public nominatedOwner;
48 
49     constructor(address _owner) public {
50         require(_owner != address(0), "Owner address cannot be 0");
51         owner = _owner;
52         emit OwnerChanged(address(0), _owner);
53     }
54 
55     function nominateNewOwner(address _owner) external onlyOwner {
56         nominatedOwner = _owner;
57         emit OwnerNominated(_owner);
58     }
59 
60     function acceptOwnership() external {
61         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
62         emit OwnerChanged(owner, nominatedOwner);
63         owner = nominatedOwner;
64         nominatedOwner = address(0);
65     }
66 
67     modifier onlyOwner {
68         _onlyOwner();
69         _;
70     }
71 
72     function _onlyOwner() private view {
73         require(msg.sender == owner, "Only the contract owner may perform this action");
74     }
75 
76     event OwnerNominated(address newOwner);
77     event OwnerChanged(address oldOwner, address newOwner);
78 }
79 
80 
81 contract ExternalRateAggregator is Owned {
82     address public oracle;
83 
84     uint private constant ORACLE_FUTURE_LIMIT = 10 minutes;
85 
86     struct RateAndUpdatedTime {
87         uint216 rate;
88         uint40 time;
89     }
90 
91     mapping(bytes32 => RateAndUpdatedTime) public rates;
92 
93     constructor(address _owner, address _oracle) public Owned(_owner) {
94         oracle = _oracle;
95     }
96 
97     function setOracle(address _oracle) external onlyOwner {
98         require(_oracle != address(0), "Address cannot be empty");
99 
100         oracle = _oracle;
101     }
102 
103     function updateRates(
104         bytes32[] calldata _currencyKeys,
105         uint216[] calldata _newRates,
106         uint timeSent
107     ) external onlyOracle {
108         require(_currencyKeys.length == _newRates.length, "Currency key array length must match rates array length.");
109         require(timeSent < (now + ORACLE_FUTURE_LIMIT), "Time is too far into the future");
110 
111         for (uint i = 0; i < _currencyKeys.length; i++) {
112             bytes32 currencyKey = _currencyKeys[i];
113             uint newRate = _newRates[i];
114 
115             require(newRate != 0, "Zero is not a valid rate, please call deleteRate instead");
116             require(currencyKey != "pUSD", "Rate of pUSD cannot be updated, it's always UNIT");
117 
118             if (timeSent < rates[currencyKey].time) {
119                 continue;
120             }
121 
122             rates[currencyKey] = RateAndUpdatedTime({rate: uint216(newRate), time: uint40(timeSent)});
123         }
124 
125         emit RatesUpdated(_currencyKeys, _newRates);
126     }
127 
128     function deleteRate(bytes32 _currencyKey) external onlyOracle {
129         delete rates[_currencyKey];
130     }
131 
132     function getRateAndUpdatedTime(bytes32 _currencyKey) external view returns (uint, uint) {
133         return (rates[_currencyKey].rate, rates[_currencyKey].time);
134     }
135 
136     modifier onlyOracle {
137         _onlyOracle();
138         _;
139     }
140 
141     function _onlyOracle() private view {
142         require(msg.sender == oracle, "Only the oracle can perform this action");
143     }
144 
145     event RatesUpdated(bytes32[] currencyKeys, uint216[] newRates);
146 }
147 
148     