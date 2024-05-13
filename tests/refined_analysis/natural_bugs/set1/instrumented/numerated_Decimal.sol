1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 pragma experimental ABIEncoderV2;
7 
8 import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
9 
10 /**
11  * @title Decimal
12  * @author dYdX
13  *
14  * Library that defines a fixed-point number with 18 decimal places.
15  */
16 library Decimal {
17     using SafeMath for uint256;
18 
19     // ============ Constants ============
20 
21     uint256 constant BASE = 10**18;
22 
23     // ============ Structs ============
24 
25 
26     struct D256 {
27         uint256 value;
28     }
29 
30     // ============ Static Functions ============
31 
32     function zero()
33     internal
34     pure
35     returns (D256 memory)
36     {
37         return D256({ value: 0 });
38     }
39 
40     function one()
41     internal
42     pure
43     returns (D256 memory)
44     {
45         return D256({ value: BASE });
46     }
47 
48     function from(
49         uint256 a
50     )
51     internal
52     pure
53     returns (D256 memory)
54     {
55         return D256({ value: a.mul(BASE) });
56     }
57 
58     function ratio(
59         uint256 a,
60         uint256 b
61     )
62     internal
63     pure
64     returns (D256 memory)
65     {
66         return D256({ value: getPartial(a, BASE, b) });
67     }
68 
69     // ============ Self Functions ============
70 
71     function add(
72         D256 memory self,
73         uint256 b
74     )
75     internal
76     pure
77     returns (D256 memory)
78     {
79         return D256({ value: self.value.add(b.mul(BASE)) });
80     }
81 
82     function sub(
83         D256 memory self,
84         uint256 b
85     )
86     internal
87     pure
88     returns (D256 memory)
89     {
90         return D256({ value: self.value.sub(b.mul(BASE)) });
91     }
92 
93     function sub(
94         D256 memory self,
95         uint256 b,
96         string memory reason
97     )
98     internal
99     pure
100     returns (D256 memory)
101     {
102         return D256({ value: self.value.sub(b.mul(BASE), reason) });
103     }
104 
105     function mul(
106         D256 memory self,
107         uint256 b
108     )
109     internal
110     pure
111     returns (D256 memory)
112     {
113         return D256({ value: self.value.mul(b) });
114     }
115 
116     function div(
117         D256 memory self,
118         uint256 b
119     )
120     internal
121     pure
122     returns (D256 memory)
123     {
124         return D256({ value: self.value.div(b) });
125     }
126 
127     function pow(
128         D256 memory self,
129         uint256 b
130     )
131     internal
132     pure
133     returns (D256 memory)
134     {
135         if (b == 0) {
136             return one();
137         }
138 
139         D256 memory temp = D256({ value: self.value });
140         for (uint256 i = 1; i < b; ++i) {
141             temp = mul(temp, self);
142         }
143 
144         return temp;
145     }
146 
147     function add(
148         D256 memory self,
149         D256 memory b
150     )
151     internal
152     pure
153     returns (D256 memory)
154     {
155         return D256({ value: self.value.add(b.value) });
156     }
157 
158     function sub(
159         D256 memory self,
160         D256 memory b
161     )
162     internal
163     pure
164     returns (D256 memory)
165     {
166         return D256({ value: self.value.sub(b.value) });
167     }
168 
169     function sub(
170         D256 memory self,
171         D256 memory b,
172         string memory reason
173     )
174     internal
175     pure
176     returns (D256 memory)
177     {
178         return D256({ value: self.value.sub(b.value, reason) });
179     }
180 
181     function mul(
182         D256 memory self,
183         D256 memory b
184     )
185     internal
186     pure
187     returns (D256 memory)
188     {
189         return D256({ value: getPartial(self.value, b.value, BASE) });
190     }
191 
192     function div(
193         D256 memory self,
194         D256 memory b
195     )
196     internal
197     pure
198     returns (D256 memory)
199     {
200         return D256({ value: getPartial(self.value, BASE, b.value) });
201     }
202 
203     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
204         return self.value == b.value;
205     }
206 
207     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
208         return compareTo(self, b) == 2;
209     }
210 
211     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
212         return compareTo(self, b) == 0;
213     }
214 
215     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
216         return compareTo(self, b) > 0;
217     }
218 
219     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
220         return compareTo(self, b) < 2;
221     }
222 
223     function isZero(D256 memory self) internal pure returns (bool) {
224         return self.value == 0;
225     }
226 
227     function asUint256(D256 memory self) internal pure returns (uint256) {
228         return self.value.div(BASE);
229     }
230 
231     // ============ Core Methods ============
232 
233     function getPartial(
234         uint256 target,
235         uint256 numerator,
236         uint256 denominator
237     )
238     private
239     pure
240     returns (uint256)
241     {
242         return target.mul(numerator).div(denominator);
243     }
244 
245     function compareTo(
246         D256 memory a,
247         D256 memory b
248     )
249     private
250     pure
251     returns (uint256)
252     {
253         if (a.value == b.value) {
254             return 1;
255         }
256         return a.value > b.value ? 2 : 0;
257     }
258 }
