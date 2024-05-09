1 /******************************************************************************\
2 
3 file:   RegBase.sol
4 ver:    0.3.3
5 updated:12-Sep-2017
6 author: Darryl Morris (o0ragman0o)
7 email:  o0ragman0o AT gmail.com
8 
9 This file is part of the SandalStraps framework
10 
11 `RegBase` provides an inheriting contract the minimal API to be compliant with 
12 `Registrar`.  It includes a set-once, `bytes32 public regName` which is refered
13 to by `Registrar` lookups.
14 
15 An owner updatable `address public owner` state variable is also provided and is
16 required by `Factory.createNew()`.
17 
18 This software is distributed in the hope that it will be useful,
19 but WITHOUT ANY WARRANTY; without even the implied warranty of
20 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
21 See MIT Licence for further details.
22 <https://opensource.org/licenses/MIT>.
23 
24 Release notes:
25 * Framworking changing to Factory v0.3.3 usage
26 \******************************************************************************/
27 
28 pragma solidity ^0.4.13;
29 
30 contract RegBaseAbstract
31 {
32     /// @dev A static identifier, set in the constructor and used for registrar
33     /// lookup
34     /// @return Registrar name SandalStraps registrars
35     bytes32 public regName;
36 
37     /// @dev An general purpose resource such as short text or a key to a
38     /// string in a StringsMap
39     /// @return resource
40     bytes32 public resource;
41     
42     /// @dev An address permissioned to enact owner restricted functions
43     /// @return owner
44     address public owner;
45     
46     /// @dev An address permissioned to take ownership of the contract
47     /// @return newOwner
48     address public newOwner;
49 
50 //
51 // Events
52 //
53 
54     /// @dev Triggered on initiation of change owner address
55     event ChangeOwnerTo(address indexed _newOwner);
56 
57     /// @dev Triggered on change of owner address
58     event ChangedOwner(address indexed _oldOwner, address indexed _newOwner);
59 
60     /// @dev Triggered when the contract accepts ownership of another contract.
61     event ReceivedOwnership(address indexed _kAddr);
62 
63     /// @dev Triggered on change of resource
64     event ChangedResource(bytes32 indexed _resource);
65 
66 //
67 // Function Abstracts
68 //
69 
70     /// @notice Will selfdestruct the contract
71     function destroy() public;
72 
73     /// @notice Initiate a change of owner to `_owner`
74     /// @param _owner The address to which ownership is to be transfered
75     function changeOwner(address _owner) public returns (bool);
76 
77     /// @notice Finalise change of ownership to newOwner
78     function acceptOwnership() public returns (bool);
79 
80     /// @notice Change the resource to `_resource`
81     /// @param _resource A key or short text to be stored as the resource.
82     function changeResource(bytes32 _resource) public returns (bool);
83 }
84 
85 
86 contract RegBase is RegBaseAbstract
87 {
88 //
89 // Constants
90 //
91 
92     bytes32 constant public VERSION = "RegBase v0.3.3";
93 
94 //
95 // State Variables
96 //
97 
98     // Declared in RegBaseAbstract for reasons that an inherited abstract
99     // function is not seen as implimented by a public state identifier of
100     // the same name.
101     
102 //
103 // Modifiers
104 //
105 
106     // Permits only the owner
107     modifier onlyOwner() {
108         require(msg.sender == owner);
109         _;
110     }
111 
112 //
113 // Functions
114 //
115 
116     /// @param _creator The calling address passed through by a factory,
117     /// typically msg.sender
118     /// @param _regName A static name referenced by a Registrar
119     /// @param _owner optional owner address if creator is not the intended
120     /// owner
121     /// @dev On 0x0 value for owner, ownership precedence is:
122     /// `_owner` else `_creator` else msg.sender
123     function RegBase(address _creator, bytes32 _regName, address _owner)
124     {
125         require(_regName != 0x0);
126         regName = _regName;
127         owner = _owner != 0x0 ? _owner : 
128                 _creator != 0x0 ? _creator : msg.sender;
129     }
130     
131     /// @notice Will selfdestruct the contract
132     function destroy()
133         public
134         onlyOwner
135     {
136         selfdestruct(msg.sender);
137     }
138     
139     /// @notice Initiate a change of owner to `_owner`
140     /// @param _owner The address to which ownership is to be transfered
141     function changeOwner(address _owner)
142         public
143         onlyOwner
144         returns (bool)
145     {
146         ChangeOwnerTo(_owner);
147         newOwner = _owner;
148         return true;
149     }
150     
151     /// @notice Finalise change of ownership to newOwner
152     function acceptOwnership()
153         public
154         returns (bool)
155     {
156         require(msg.sender == newOwner);
157         ChangedOwner(owner, msg.sender);
158         owner = newOwner;
159         delete newOwner;
160         return true;
161     }
162 
163     /// @notice Change the resource to `_resource`
164     /// @param _resource A key or short text to be stored as the resource.
165     function changeResource(bytes32 _resource)
166         public
167         onlyOwner
168         returns (bool)
169     {
170         resource = _resource;
171         ChangedResource(_resource);
172         return true;
173     }
174 }
175 
176 /******************************************************************************\
177 
178 file:   Factory.sol
179 ver:    0.3.3
180 updated:12-Sep-2017
181 author: Darryl Morris (o0ragman0o)
182 email:  o0ragman0o AT gmail.com
183 
184 This file is part of the SandalStraps framework
185 
186 Factories are a core but independant concept of the SandalStraps framework and 
187 can be used to create SandalStraps compliant 'product' contracts from embed
188 bytecode.
189 
190 The abstract Factory contract is to be used as a SandalStraps compliant base for
191 product specific factories which must impliment the createNew() function.
192 
193 is itself compliant with `Registrar` by inhereting `RegBase` and
194 compiant with `Factory` through the `createNew(bytes32 _name, address _owner)`
195 API.
196 
197 An optional creation fee can be set and manually collected by the owner.
198 
199 This software is distributed in the hope that it will be useful,
200 but WITHOUT ANY WARRANTY; without even the implied warranty of
201 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
202 See MIT Licence for further details.
203 <https://opensource.org/licenses/MIT>.
204 
205 Release Notes
206 -------------
207 * Changed from`withdaw(<value>)` to `withdrawAll()`
208 \******************************************************************************/
209 
210 pragma solidity ^0.4.13;
211 
212 // import "./RegBase.sol";
213 
214 contract Factory is RegBase
215 {
216 //
217 // Constants
218 //
219 
220     // Deriving factories should have `bytes32 constant public regName` being
221     // the product's contract name, e.g for products "Foo":
222     // bytes32 constant public regName = "Foo";
223 
224     // Deriving factories should have `bytes32 constant public VERSION` being
225     // the product's contract name appended with 'Factory` and the version
226     // of the product, e.g for products "Foo":
227     // bytes32 constant public VERSION "FooFactory 0.0.1";
228 
229 //
230 // State Variables
231 //
232 
233     /// @return The payment in wei required to create the product contract.
234     uint public value;
235 
236 //
237 // Events
238 //
239 
240     // Is triggered when a product is created
241     event Created(address indexed _creator, bytes32 indexed _regName, address indexed _addr);
242 
243 //
244 // Modifiers
245 //
246 
247     // To check that the correct fee has bene paid
248     modifier feePaid() {
249         require(msg.value == value || msg.sender == owner);
250         _;
251     }
252 
253 //
254 // Functions
255 //
256 
257     /// @param _creator The calling address passed through by a factory,
258     /// typically msg.sender
259     /// @param _regName A static name referenced by a Registrar
260     /// @param _owner optional owner address if creator is not the intended
261     /// owner
262     /// @dev On 0x0 value for _owner or _creator, ownership precedence is:
263     /// `_owner` else `_creator` else msg.sender
264     function Factory(address _creator, bytes32 _regName, address _owner)
265         RegBase(_creator, _regName, _owner)
266     {
267         // nothing left to construct
268     }
269     
270     /// @notice Set the product creation fee
271     /// @param _fee The desired fee in wei
272     function set(uint _fee) 
273         onlyOwner
274         returns (bool)
275     {
276         value = _fee;
277         return true;
278     }
279 
280     /// @notice Send contract balance to `owner`
281     function withdrawAll()
282         public
283         returns (bool)
284     {
285         owner.transfer(this.balance);
286         return true;
287     }
288 
289     /// @notice Create a new product contract
290     /// @param _regName A unique name if the the product is to be registered in
291     /// a SandalStraps registrar
292     /// @param _owner An address of a third party owner.  Will default to
293     /// msg.sender if 0x0
294     /// @return kAddr_ The address of the new product contract
295     function createNew(bytes32 _regName, address _owner) 
296         payable returns(address kAddr_);
297 }
298 
299 /******************************************************************************\
300 
301 file:   Forwarder.sol
302 ver:    0.3.0
303 updated:4-Oct-2017
304 author: Darryl Morris (o0ragman0o)
305 email:  o0ragman0o AT gmail.com
306 
307 This file is part of the SandalStraps framework
308 
309 Forwarder acts as a proxy address for payment pass-through.
310 
311 This software is distributed in the hope that it will be useful,
312 but WITHOUT ANY WARRANTY; without even the implied warranty of
313 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
314 See MIT Licence for further details.
315 <https://opensource.org/licenses/MIT>.
316 
317 Release Notes
318 -------------
319 * Name change from 'Redirector' to 'Forwarder'
320 * Changes state name from 'payTo' to 'forwardTo'
321 
322 \******************************************************************************/
323 
324 pragma solidity ^0.4.13;
325 
326 // import "https://github.com/o0ragman0o/SandalStraps/contracts/Factory.sol";
327 
328 contract Forwarder is RegBase {
329 //
330 // Constants
331 //
332 
333     bytes32 constant public VERSION = "Forwarder v0.3.0";
334 
335 //
336 // State
337 //
338 
339     address public forwardTo;
340     
341 //
342 // Events
343 //
344     
345     event Forwarded(
346         address indexed _from,
347         address indexed _to,
348         uint _value);
349 
350 //
351 // Functions
352 //
353 
354     function Forwarder(address _creator, bytes32 _regName, address _owner)
355         public
356         RegBase(_creator, _regName, _owner)
357     {
358         // forwardTo will be set to msg.sender of if _owner == 0x0 or _owner
359         // otherwise
360         forwardTo = owner;
361     }
362     
363     function ()
364         public
365         payable 
366     {
367         Forwarded(msg.sender, forwardTo, msg.value);
368         require(forwardTo.call.value(msg.value)(msg.data));
369     }
370     
371     function changeForwardTo(address _forwardTo)
372         public
373         returns (bool)
374     {
375         // Only owner or forwarding address can change forwarding address 
376         require(msg.sender == owner || msg.sender == forwardTo);
377         forwardTo = _forwardTo;
378         return true;
379     }
380 }
381 
382 
383 contract ForwarderFactory is Factory
384 {
385 //
386 // Constants
387 //
388 
389     /// @return registrar name
390     bytes32 constant public regName = "forwarder";
391     
392     /// @return version string
393     bytes32 constant public VERSION = "ForwarderFactory v0.3.0";
394 
395 //
396 // Functions
397 //
398 
399     /// @param _creator The calling address passed through by a factory,
400     /// typically msg.sender
401     /// @param _regName A static name referenced by a Registrar
402     /// @param _owner optional owner address if creator is not the intended
403     /// owner
404     /// @dev On 0x0 value for _owner or _creator, ownership precedence is:
405     /// `_owner` else `_creator` else msg.sender
406     function ForwarderFactory(
407             address _creator, bytes32 _regName, address _owner) public
408         Factory(_creator, regName, _owner)
409     {
410         // _regName is ignored as `regName` is already a constant
411         // nothing to construct
412     }
413 
414     /// @notice Create a new product contract
415     /// @param _regName A unique name if the the product is to be registered in
416     /// a SandalStraps registrar
417     /// @param _owner An address of a third party owner.  Will default to
418     /// msg.sender if 0x0
419     /// @return kAddr_ The address of the new product contract
420     function createNew(bytes32 _regName, address _owner)
421         public
422         payable
423         feePaid
424         returns (address kAddr_)
425     {
426         kAddr_ = address(new Forwarder(msg.sender, _regName, _owner));
427         Created(msg.sender, _regName, kAddr_);
428     }
429 }