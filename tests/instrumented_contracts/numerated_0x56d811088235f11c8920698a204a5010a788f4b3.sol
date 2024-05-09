1 /**
2  * Copyright 2017-2020, bZeroX, LLC <https://bzx.network/>. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5 
6 pragma solidity 0.5.17;
7 
8 
9 contract IERC20 {
10     string public name;
11     uint8 public decimals;
12     string public symbol;
13     function totalSupply() public view returns (uint256);
14     function balanceOf(address _who) public view returns (uint256);
15     function allowance(address _owner, address _spender) public view returns (uint256);
16     function approve(address _spender, uint256 _value) public returns (bool);
17     function transfer(address _to, uint256 _value) public returns (bool);
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 /**
24  * Copyright (C) 2019 Aragon One <https://aragon.one/>
25  *
26  *  This program is free software: you can redistribute it and/or modify
27  *  it under the terms of the GNU General Public License as published by
28  *  the Free Software Foundation, either version 3 of the License, or
29  *  (at your option) any later version.
30  *
31  *  This program is distributed in the hope that it will be useful,
32  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
33  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
34  *  GNU General Public License for more details.
35  *
36  *  You should have received a copy of the GNU General Public License
37  *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
38  */
39 /**
40  * @title Checkpointing
41  * @notice Checkpointing library for keeping track of historical values based on an arbitrary time
42  *         unit (e.g. seconds or block numbers).
43  * @dev Adapted from:
44  *   - Checkpointing  (https://github.com/aragonone/voting-connectors/blob/master/shared/contract-utils/contracts/Checkpointing.sol)
45  */
46 library Checkpointing {
47 
48     struct Checkpoint {
49         uint256 time;
50         uint256 value;
51     }
52 
53     struct History {
54         Checkpoint[] history;
55     }
56 
57     function addCheckpoint(
58         History storage _self,
59         uint256 _time,
60         uint256 _value)
61         internal
62     {
63         uint256 length = _self.history.length;
64         if (length == 0) {
65             _self.history.push(Checkpoint(_time, _value));
66         } else {
67             Checkpoint storage currentCheckpoint = _self.history[length - 1];
68             uint256 currentCheckpointTime = currentCheckpoint.time;
69 
70             if (_time > currentCheckpointTime) {
71                 _self.history.push(Checkpoint(_time, _value));
72             } else if (_time == currentCheckpointTime) {
73                 currentCheckpoint.value = _value;
74             } else { // ensure list ordering
75                 revert("past-checkpoint");
76             }
77         }
78     }
79 
80     function getValueAt(
81         History storage _self,
82         uint256 _time)
83         internal
84         view
85         returns (uint256)
86     {
87         return _getValueAt(_self, _time);
88     }
89 
90     function lastUpdated(
91         History storage _self)
92         internal
93         view
94         returns (uint256)
95     {
96         uint256 length = _self.history.length;
97         if (length != 0) {
98             return _self.history[length - 1].time;
99         }
100     }
101 
102     function latestValue(
103         History storage _self)
104         internal
105         view
106         returns (uint256)
107     {
108         uint256 length = _self.history.length;
109         if (length != 0) {
110             return _self.history[length - 1].value;
111         }
112     }
113 
114     function _getValueAt(
115         History storage _self,
116         uint256 _time)
117         private
118         view
119         returns (uint256)
120     {
121         uint256 length = _self.history.length;
122 
123         // Short circuit if there's no checkpoints yet
124         // Note that this also lets us avoid using SafeMath later on, as we've established that
125         // there must be at least one checkpoint
126         if (length == 0) {
127             return 0;
128         }
129 
130         // Check last checkpoint
131         uint256 lastIndex = length - 1;
132         Checkpoint storage lastCheckpoint = _self.history[lastIndex];
133         if (_time >= lastCheckpoint.time) {
134             return lastCheckpoint.value;
135         }
136 
137         // Check first checkpoint (if not already checked with the above check on last)
138         if (length == 1 || _time < _self.history[0].time) {
139             return 0;
140         }
141 
142         // Do binary search
143         // As we've already checked both ends, we don't need to check the last checkpoint again
144         uint256 low = 0;
145         uint256 high = lastIndex - 1;
146 
147         while (high != low) {
148             uint256 mid = (high + low + 1) / 2; // average, ceil round
149             Checkpoint storage checkpoint = _self.history[mid];
150             uint256 midTime = checkpoint.time;
151 
152             if (_time > midTime) {
153                 low = mid;
154             } else if (_time < midTime) {
155                 // Note that we don't need SafeMath here because mid must always be greater than 0
156                 // from the while condition
157                 high = mid - 1;
158             } else {
159                 // _time == midTime
160                 return checkpoint.value;
161             }
162         }
163 
164         return _self.history[low].value;
165     }
166 }
167 
168 contract CheckpointingToken is IERC20 {
169     using Checkpointing for Checkpointing.History;
170 
171     mapping (address => mapping (address => uint256)) internal allowances_;
172 
173     mapping (address => Checkpointing.History) internal balancesHistory_;
174 
175     struct Checkpoint {
176         uint256 time;
177         uint256 value;
178     }
179 
180     struct History {
181         Checkpoint[] history;
182     }
183 
184     // override this function if a totalSupply should be tracked
185     function totalSupply()
186         public
187         view
188         returns (uint256)
189     {
190         return 0;
191     }
192 
193     function balanceOf(
194         address _owner)
195         public
196         view
197         returns (uint256)
198     {
199         return balanceOfAt(_owner, block.number);
200     }
201 
202     function balanceOfAt(
203         address _owner,
204         uint256 _blockNumber)
205         public
206         view
207         returns (uint256)
208     {
209         return balancesHistory_[_owner].getValueAt(_blockNumber);
210     }
211 
212     function allowance(
213         address _owner,
214         address _spender)
215         public
216         view
217         returns (uint256)
218     {
219         return allowances_[_owner][_spender];
220     }
221 
222     function approve(
223         address _spender,
224         uint256 _value)
225         public
226         returns (bool)
227     {
228         allowances_[msg.sender][_spender] = _value;
229         emit Approval(msg.sender, _spender, _value);
230         return true;
231     }
232 
233     function transfer(
234         address _to,
235         uint256 _value)
236         public
237         returns (bool)
238     {
239         return transferFrom(
240             msg.sender,
241             _to,
242             _value
243         );
244     }
245 
246     function transferFrom(
247         address _from,
248         address _to,
249         uint256 _value)
250         public
251         returns (bool)
252     {
253         uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
254         require(previousBalanceFrom >= _value, "insufficient-balance");
255 
256         if (_from != msg.sender && allowances_[_from][msg.sender] != uint(-1)) {
257             require(allowances_[_from][msg.sender] >= _value, "insufficient-allowance");
258             allowances_[_from][msg.sender] = allowances_[_from][msg.sender] - _value; // overflow not possible
259         }
260 
261         balancesHistory_[_from].addCheckpoint(
262             block.number,
263             previousBalanceFrom - _value // overflow not possible
264         );
265 
266         balancesHistory_[_to].addCheckpoint(
267             block.number,
268             add(
269                 balanceOfAt(_to, block.number),
270                 _value
271             )
272         );
273 
274         emit Transfer(_from, _to, _value);
275         return true;
276     }
277 
278     function _getBlockNumber()
279         internal
280         view
281         returns (uint256)
282     {
283         return block.number;
284     }
285 
286     function _getTimestamp()
287         internal
288         view
289         returns (uint256)
290     {
291         return block.timestamp;
292     }
293 
294     function add(
295         uint256 x,
296         uint256 y)
297         internal
298         pure
299         returns (uint256 c)
300     {
301         require((c = x + y) >= x, "addition-overflow");
302     }
303 
304     function sub(
305         uint256 x,
306         uint256 y)
307         internal
308         pure
309         returns (uint256 c)
310     {
311         require((c = x - y) <= x, "subtraction-overflow");
312     }
313 
314     function mul(
315         uint256 a,
316         uint256 b)
317         internal
318         pure
319         returns (uint256 c)
320     {
321         if (a == 0) {
322             return 0;
323         }
324         require((c = a * b) / a == b, "multiplication-overflow");
325     }
326 
327     function div(
328         uint256 a,
329         uint256 b)
330         internal
331         pure
332         returns (uint256 c)
333     {
334         require(b != 0, "division by zero");
335         c = a / b;
336     }
337 }
338 
339 contract BZRXToken is CheckpointingToken {
340 
341     string public constant name = "bZx Protocol Token";
342     string public constant symbol = "BZRX";
343     uint8 public constant decimals = 18;
344 
345     uint256 internal constant totalSupply_ = 1030000000e18; // 1,030,000,000 BZRX
346 
347     constructor(
348         address _to)
349         public
350     {
351         balancesHistory_[_to].addCheckpoint(_getBlockNumber(), totalSupply_);
352         emit Transfer(address(0), _to, totalSupply_);
353     }
354 
355     function totalSupply()
356         public
357         view
358         returns (uint256)
359     {
360         return totalSupply_;
361     }
362 }