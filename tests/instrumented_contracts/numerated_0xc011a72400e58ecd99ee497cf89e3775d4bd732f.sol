1 /* 
2  * Havven Token Contract Proxy
3  * ========================
4  * 
5  * This contract points to an underlying target which implements its
6  * actual functionality, while allowing that functionality to be upgraded.
7  */
8 
9 pragma solidity 0.4.24;
10 
11 /**
12  * @title A contract with an owner.
13  * @notice Contract ownership can be transferred by first nominating the new owner,
14  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
15  */
16 contract Owned {
17     address public owner;
18     address public nominatedOwner;
19 
20     /**
21      * @dev Owned Constructor
22      */
23     constructor(address _owner)
24         public
25     {
26         require(_owner != address(0));
27         owner = _owner;
28         emit OwnerChanged(address(0), _owner);
29     }
30 
31     /**
32      * @notice Nominate a new owner of this contract.
33      * @dev Only the current owner may nominate a new owner.
34      */
35     function nominateNewOwner(address _owner)
36         external
37         onlyOwner
38     {
39         nominatedOwner = _owner;
40         emit OwnerNominated(_owner);
41     }
42 
43     /**
44      * @notice Accept the nomination to be owner.
45      */
46     function acceptOwnership()
47         external
48     {
49         require(msg.sender == nominatedOwner);
50         emit OwnerChanged(owner, nominatedOwner);
51         owner = nominatedOwner;
52         nominatedOwner = address(0);
53     }
54 
55     modifier onlyOwner
56     {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     event OwnerNominated(address newOwner);
62     event OwnerChanged(address oldOwner, address newOwner);
63 }
64 
65 // This contract should be treated like an abstract contract
66 contract Proxyable is Owned {
67     /* The proxy this contract exists behind. */
68     Proxy public proxy;
69 
70     /* The caller of the proxy, passed through to this contract.
71      * Note that every function using this member must apply the onlyProxy or
72      * optionalProxy modifiers, otherwise their invocations can use stale values. */ 
73     address messageSender; 
74 
75     constructor(address _proxy, address _owner)
76         Owned(_owner)
77         public
78     {
79         proxy = Proxy(_proxy);
80         emit ProxyUpdated(_proxy);
81     }
82 
83     function setProxy(address _proxy)
84         external
85         onlyOwner
86     {
87         proxy = Proxy(_proxy);
88         emit ProxyUpdated(_proxy);
89     }
90 
91     function setMessageSender(address sender)
92         external
93         onlyProxy
94     {
95         messageSender = sender;
96     }
97 
98     modifier onlyProxy {
99         require(Proxy(msg.sender) == proxy);
100         _;
101     }
102 
103     modifier optionalProxy
104     {
105         if (Proxy(msg.sender) != proxy) {
106             messageSender = msg.sender;
107         }
108         _;
109     }
110 
111     modifier optionalProxy_onlyOwner
112     {
113         if (Proxy(msg.sender) != proxy) {
114             messageSender = msg.sender;
115         }
116         require(messageSender == owner);
117         _;
118     }
119 
120     event ProxyUpdated(address proxyAddress);
121 }
122 
123 contract Proxy is Owned {
124 
125     Proxyable public target;
126     bool public useDELEGATECALL;
127 
128     constructor(address _owner)
129         Owned(_owner)
130         public
131     {}
132 
133     function setTarget(Proxyable _target)
134         external
135         onlyOwner
136     {
137         target = _target;
138         emit TargetUpdated(_target);
139     }
140 
141     function setUseDELEGATECALL(bool value) 
142         external
143         onlyOwner
144     {
145         useDELEGATECALL = value;
146     }
147 
148     function _emit(bytes callData, uint numTopics,
149                    bytes32 topic1, bytes32 topic2,
150                    bytes32 topic3, bytes32 topic4)
151         external
152         onlyTarget
153     {
154         uint size = callData.length;
155         bytes memory _callData = callData;
156 
157         assembly {
158             /* The first 32 bytes of callData contain its length (as specified by the abi). 
159              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
160              * in length. It is also leftpadded to be a multiple of 32 bytes.
161              * This means moving call_data across 32 bytes guarantees we correctly access
162              * the data itself. */
163             switch numTopics
164             case 0 {
165                 log0(add(_callData, 32), size)
166             } 
167             case 1 {
168                 log1(add(_callData, 32), size, topic1)
169             }
170             case 2 {
171                 log2(add(_callData, 32), size, topic1, topic2)
172             }
173             case 3 {
174                 log3(add(_callData, 32), size, topic1, topic2, topic3)
175             }
176             case 4 {
177                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
178             }
179         }
180     }
181 
182     function()
183         external
184         payable
185     {
186         if (useDELEGATECALL) {
187             assembly {
188                 /* Copy call data into free memory region. */
189                 let free_ptr := mload(0x40)
190                 calldatacopy(free_ptr, 0, calldatasize)
191 
192                 /* Forward all gas and call data to the target contract. */
193                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
194                 returndatacopy(free_ptr, 0, returndatasize)
195 
196                 /* Revert if the call failed, otherwise return the result. */
197                 if iszero(result) { revert(free_ptr, returndatasize) }
198                 return(free_ptr, returndatasize)
199             }
200         } else {
201             /* Here we are as above, but must send the messageSender explicitly 
202              * since we are using CALL rather than DELEGATECALL. */
203             target.setMessageSender(msg.sender);
204             assembly {
205                 let free_ptr := mload(0x40)
206                 calldatacopy(free_ptr, 0, calldatasize)
207 
208                 /* We must explicitly forward ether to the underlying contract as well. */
209                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
210                 returndatacopy(free_ptr, 0, returndatasize)
211 
212                 if iszero(result) { revert(free_ptr, returndatasize) }
213                 return(free_ptr, returndatasize)
214             }
215         }
216     }
217 
218     modifier onlyTarget {
219         require(Proxyable(msg.sender) == target);
220         _;
221     }
222 
223     event TargetUpdated(Proxyable newTarget);
224 }