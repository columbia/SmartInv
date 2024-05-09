1 /*
2 -----------------------------------------------------------------
3 FILE HEADER
4 -----------------------------------------------------------------
5 
6 file:       Proxy.sol
7 version:    1.0
8 authors:    Anton Jurisevic
9             Dominic Romanowski
10 
11 date:       2018-2-28
12 checked:    Mike Spain
13 approved:   Samuel Brooks
14 
15 repo:       https://github.com/Havven/havven
16 commit:     34e66009b98aa18976226c139270970d105045e3
17 
18 -----------------------------------------------------------------
19 */
20 
21 pragma solidity ^0.4.21;
22 
23 /*
24 -----------------------------------------------------------------
25 CONTRACT DESCRIPTION
26 -----------------------------------------------------------------
27 
28 An Owned contract, to be inherited by other contracts.
29 Requires its owner to be explicitly set in the constructor.
30 Provides an onlyOwner access modifier.
31 
32 To change owner, the current owner must nominate the next owner,
33 who then has to accept the nomination. The nomination can be
34 cancelled before it is accepted by the new owner by having the
35 previous owner change the nomination (setting it to 0).
36 
37 -----------------------------------------------------------------
38 */
39 
40 contract Owned {
41     address public owner;
42     address public nominatedOwner;
43 
44     function Owned(address _owner)
45         public
46     {
47         owner = _owner;
48     }
49 
50     function nominateOwner(address _owner)
51         external
52         onlyOwner
53     {
54         nominatedOwner = _owner;
55         emit OwnerNominated(_owner);
56     }
57 
58     function acceptOwnership()
59         external
60     {
61         require(msg.sender == nominatedOwner);
62         emit OwnerChanged(owner, nominatedOwner);
63         owner = nominatedOwner;
64         nominatedOwner = address(0);
65     }
66 
67     modifier onlyOwner
68     {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     event OwnerNominated(address newOwner);
74     event OwnerChanged(address oldOwner, address newOwner);
75 }
76 
77 /*
78 -----------------------------------------------------------------
79 CONTRACT DESCRIPTION
80 -----------------------------------------------------------------
81 
82 A proxy contract that, if it does not recognise the function
83 being called on it, passes all value and call data to an
84 underlying target contract.
85 
86 -----------------------------------------------------------------
87 */
88 
89 contract Proxy is Owned {
90     Proxyable target;
91 
92     function Proxy(Proxyable _target, address _owner)
93         Owned(_owner)
94         public
95     {
96         target = _target;
97         emit TargetChanged(_target);
98     }
99 
100     function _setTarget(address _target) 
101         external
102         onlyOwner
103     {
104         require(_target != address(0));
105         target = Proxyable(_target);
106         emit TargetChanged(_target);
107     }
108 
109     function () 
110         public
111         payable
112     {
113         target.setMessageSender(msg.sender);
114         assembly {
115             // Copy call data into free memory region.
116             let free_ptr := mload(0x40)
117             calldatacopy(free_ptr, 0, calldatasize)
118 
119             // Forward all gas, ether, and data to the target contract.
120             let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
121             returndatacopy(free_ptr, 0, returndatasize)
122 
123             // Revert if the call failed, otherwise return the result.
124             if iszero(result) { revert(free_ptr, calldatasize) }
125             return(free_ptr, returndatasize)
126         } 
127     }
128 
129     event TargetChanged(address targetAddress);
130 }
131 
132 /*
133 -----------------------------------------------------------------
134 CONTRACT DESCRIPTION
135 -----------------------------------------------------------------
136 
137 This contract is the Proxyable interface. Any contract the proxy
138 wraps must implement this, in order for the proxy to be able to
139 pass msg.sender into the underlying contract as the state
140 parameter, messageSender.
141 
142 -----------------------------------------------------------------
143 */
144 
145 contract Proxyable is Owned {
146     // the proxy this contract exists behind.
147     Proxy public proxy;
148 
149     // The caller of the proxy, passed through to this contract.
150     // Note that every function using this member must apply the onlyProxy or
151     // optionalProxy modifiers, otherwise their invocations can use stale values.
152     address messageSender;
153 
154     function Proxyable(address _owner)
155         Owned(_owner)
156         public { }
157 
158     function setProxy(Proxy _proxy)
159         external
160         onlyOwner
161     {
162         proxy = _proxy;
163         emit ProxyChanged(_proxy);
164     }
165 
166     function setMessageSender(address sender)
167         external
168         onlyProxy
169     {
170         messageSender = sender;
171     }
172 
173     modifier onlyProxy
174     {
175         require(Proxy(msg.sender) == proxy);
176         _;
177     }
178 
179     modifier onlyOwner_Proxy
180     {
181         require(messageSender == owner);
182         _;
183     }
184 
185     modifier optionalProxy
186     {
187         if (Proxy(msg.sender) != proxy) {
188             messageSender = msg.sender;
189         }
190         _;
191     }
192 
193     // Combine the optionalProxy and onlyOwner_Proxy modifiers.
194     // This is slightly cheaper and safer, since there is an ordering requirement.
195     modifier optionalProxy_onlyOwner
196     {
197         if (Proxy(msg.sender) != proxy) {
198             messageSender = msg.sender;
199         }
200         require(messageSender == owner);
201         _;
202     }
203 
204     event ProxyChanged(address proxyAddress);
205 
206 }
207 
208 /*
209 MIT License
210 
211 Copyright (c) 2018 Havven
212 
213 Permission is hereby granted, free of charge, to any person obtaining a copy
214 of this software and associated documentation files (the "Software"), to deal
215 in the Software without restriction, including without limitation the rights
216 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
217 copies of the Software, and to permit persons to whom the Software is
218 furnished to do so, subject to the following conditions:
219 
220 The above copyright notice and this permission notice shall be included in all
221 copies or substantial portions of the Software.
222 
223 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
224 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
225 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
226 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
227 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
228 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
229 SOFTWARE.
230 */