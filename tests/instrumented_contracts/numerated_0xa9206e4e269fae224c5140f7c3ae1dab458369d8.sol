1 /*
2 -----------------------------------------------------------------
3 FILE INFORMATION
4 -----------------------------------------------------------------
5 
6 file:       EventRecorder.sol
7 version:    1.0
8 date:       2019-9-12
9 author:     Hamish Ivison
10             Dominic Romanowski
11 
12 -----------------------------------------------------------------
13 CONTRACT DESCRIPTION
14 -----------------------------------------------------------------
15 
16 A contract with an owner, that can push arbitrary data to be emitted
17 as an event.
18 
19 The intention of this contract is to post a merkle tree root hash of
20 a group of events, to ensure that data from an external source can
21 be validated as having not been altered.
22 
23 -----------------------------------------------------------------
24 */
25 pragma solidity 0.5.12;
26 
27 /*
28 -----------------------------------------------------------------
29 MODULE INFORMATION
30 -----------------------------------------------------------------
31 
32 contract:   Owned
33 version:    1.1
34 date:       2018-2-26
35 author:     Anton Jurisevic
36             Dominic Romanowski
37 
38 Auditors: Sigma Prime - https://github.com/sigp/havven-audit
39 
40 A contract with an owner, to be inherited by other contracts.
41 Requires its owner to be explicitly set in the constructor.
42 Provides an onlyOwner access modifier.
43 
44 To change owner, the current owner must nominate the next owner,
45 who then has to accept the nomination. The nomination can be
46 cancelled before it is accepted by the new owner by having the
47 previous owner change the nomination (setting it to 0).
48 
49 If the ownership is to be relinquished, then it can be handed
50 to a smart contract whose only function is to accept that
51 ownership, which guarantees no owner-only functionality can
52 ever be invoked.
53 
54 -----------------------------------------------------------------
55 */
56 
57 /**
58  * @title A contract with an owner.
59  * @notice Contract ownership is transferred by first nominating the new owner,
60  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
61  */
62 contract Owned {
63     address public owner;
64     address public nominatedOwner;
65 
66     /**
67      * @dev Owned Constructor
68      * @param _owner The initial owner of the contract.
69      */
70     constructor(address _owner)
71         public
72     {
73         require(_owner != address(0), "Null owner address.");
74         owner = _owner;
75         emit OwnerChanged(address(0), _owner);
76     }
77 
78     /**
79      * @notice Nominate a new owner of this contract.
80      * @dev Only the current owner may nominate a new owner.
81      * @param _owner The new owner to be nominated.
82      */
83     function nominateNewOwner(address _owner)
84         public
85         onlyOwner
86     {
87         nominatedOwner = _owner;
88         emit OwnerNominated(_owner);
89     }
90 
91     /**
92      * @notice Accept the nomination to be owner.
93      */
94     function acceptOwnership()
95         external
96     {
97         require(msg.sender == nominatedOwner, "Not nominated.");
98         emit OwnerChanged(owner, nominatedOwner);
99         owner = nominatedOwner;
100         nominatedOwner = address(0);
101     }
102 
103     modifier onlyOwner
104     {
105         require(msg.sender == owner, "Not owner.");
106         _;
107     }
108 
109     event OwnerNominated(address newOwner);
110     event OwnerChanged(address oldOwner, address newOwner);
111 }
112 
113 /**
114  * @title A contract for recording events.
115  */
116 contract EventRecorder is Owned {
117 
118     /**
119      * @dev Owned Constructor
120      * @param _owner The initial owner of the contract.
121      */
122     constructor(address _owner) Owned(_owner) public {}
123 
124     /**
125      * @notice Post arbitrary data to the blockchain.
126      */
127     function publishEvent(bytes memory data) public onlyOwner {
128         emit IglooEvent(data);
129     }
130 
131     event IglooEvent(bytes eventData);
132 }
133 
134 /*
135 -----------------------------------------------------------------------------
136 MIT License
137 
138 Copyright © Havven 2018, Igloo 2019.
139 
140 Permission is hereby granted, free of charge, to any person obtaining a copy
141 of this software and associated documentation files (the "Software"), to deal
142 in the Software without restriction, including without limitation the rights
143 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
144 copies of the Software, and to permit persons to whom the Software is
145 furnished to do so, subject to the following conditions:
146 
147 The above copyright notice and this permission notice shall be included in
148 all copies or substantial portions of the Software.
149 
150 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
151 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
152 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
153 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
154 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
155 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
156 SOFTWARE.
157 -----------------------------------------------------------------------------
158 */