1 /**
2  * SimpleRegistrar lets you claim a subdomain name for yourself and configure it
3  * all in one step. This one is deployed at registrar.gimmethe.eth.
4  * 
5  * To use it, simply call register() with the name you want and the appropriate
6  * fee (initially 0.01 ether, but adjustable over time; call fee() to get the
7  * current price). For example, in a web3 console:
8  * 
9  *     var simpleRegistrarContract = web3.eth.contract([{"constant":true,"inputs":[],"name":"fee","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"name","type":"string"}],"name":"register","outputs":[],"payable":true,"type":"function"}]);
10  *     var simpleRegistrar = simpleRegistrarContract.at("0x1bebbc372772817d5d11a06ee2a4eba33ab6ee65");
11  *     simpleRegistrar.register('myname', {from: accounts[0], value: simpleRegistrar.fee(), gas: 150000});
12  * 
13  * SimpleRegistrar will take care of everything: registering your subdomain,
14  * setting up a resolver, and pointing that resolver at the account that called
15  * it.
16  * 
17  * Funds received from running this service are reinvested into building new
18  * ENS tools and utilities.
19  * 
20  * Note that the Deed owning gimmethe.eth is not currently in a holding
21  * contract, so I could theoretically change the registrar at any time. This is
22  * a temporary measure, as it may be necessary to replace this contract with an
23  * updated one as ENS best practices change. You have only my word that I will
24  * never interfere with a properly registered subdomain of gimmethe.eth.
25  * 
26  * Author: Nick Johnson <nick@arachnidlabs.com>
27  * Copyright 2017, Nick Johnson
28  * Licensed under the Apache Public License, version 2.0.
29  */
30 pragma solidity ^0.4.10;
31 
32 contract AbstractENS {
33     function owner(bytes32 node) constant returns(address);
34     function resolver(bytes32 node) constant returns(address);
35     function ttl(bytes32 node) constant returns(uint64);
36     function setOwner(bytes32 node, address owner);
37     function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
38     function setResolver(bytes32 node, address resolver);
39     function setTTL(bytes32 node, uint64 ttl);
40 }
41 
42 contract owned {
43     address owner;
44     
45     function owned() {
46         owner = msg.sender;
47     }
48     
49     modifier owner_only() {
50         if(msg.sender != owner) throw;
51         _;
52     }
53     
54     function setOwner(address _owner) owner_only {
55         owner = _owner;
56     }
57 }
58 
59 contract Resolver {
60     function setAddr(bytes32 node, address addr);
61 }
62 
63 contract ReverseRegistrar {
64     function claim(address owner) returns (bytes32 node);
65 }
66 
67 contract SimpleRegistrar is owned {
68     // namehash('addr.reverse')
69     bytes32 constant RR_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
70 
71     event HashRegistered(bytes32 indexed hash, address indexed owner);
72 
73     AbstractENS public ens;
74     bytes32 public rootNode;
75     uint public fee;
76     // Temporary until we have a public address for it
77     Resolver public resolver;
78     
79     function SimpleRegistrar(AbstractENS _ens, bytes32 _rootNode, uint _fee, Resolver _resolver) {
80         ens = _ens;
81         rootNode = _rootNode;
82         fee = _fee;
83         resolver = _resolver;
84         
85         // Assign reverse record to sender
86         ReverseRegistrar(ens.owner(RR_NODE)).claim(msg.sender);
87     }
88     
89     function withdraw() owner_only {
90         if(!msg.sender.send(this.balance)) throw;
91     }
92     
93     function setFee(uint _fee) owner_only {
94         fee = _fee;
95     }
96     
97     function setResolver(Resolver _resolver) owner_only {
98         resolver = _resolver;
99     }
100     
101     modifier can_register(bytes32 label) {
102         if(ens.owner(label) != 0 || msg.value < fee) throw;
103         _;
104     }
105     
106     function register(string name) payable can_register(sha3(name)) {
107         var label = sha3(name);
108         
109         // First register the name to ourselves
110         ens.setSubnodeOwner(rootNode, label, this);
111         
112         // Now set a resolver up
113         var node = sha3(rootNode, label);
114         ens.setResolver(node, resolver);
115         resolver.setAddr(node, msg.sender);
116         
117         // Now transfer ownership to the user
118         ens.setOwner(node, msg.sender);
119         
120         HashRegistered(label, msg.sender);
121         
122         // Send any excess ether back
123         if(msg.value > fee) {
124             if(!msg.sender.send(msg.value - fee)) throw;
125         }
126     }
127 }