1 //! DappReg is a Dapp Registry
2 //! By Parity Team (Ethcore), 2016.
3 //! Released under the Apache Licence 2.
4 
5 pragma solidity ^0.4.1;
6 
7 contract Owned {
8   event NewOwner(address indexed old, address indexed current);
9 
10   modifier only_owner {
11     if (msg.sender != owner) throw;
12     _;
13   }
14 
15   address public owner = msg.sender;
16 
17   function setOwner(address _new) only_owner {
18     NewOwner(owner, _new);
19     owner = _new;
20   }
21 }
22 
23 contract DappReg is Owned {
24   // id       - shared to be the same accross all contracts for a specific dapp (including GithuHint for the repo)
25   // owner    - that guy
26   // meta     - meta information for the dapp
27   struct Dapp {
28     bytes32 id;
29     address owner;
30     mapping (bytes32 => bytes32) meta;
31   }
32 
33   modifier when_fee_paid {
34     if (msg.value < fee) throw;
35     _;
36   }
37 
38   modifier only_dapp_owner(bytes32 _id) {
39     if (dapps[_id].owner != msg.sender) throw;
40     _;
41   }
42 
43   modifier either_owner(bytes32 _id) {
44     if (dapps[_id].owner != msg.sender && owner != msg.sender) throw;
45     _;
46   }
47 
48   modifier when_id_free(bytes32 _id) {
49     if (dapps[_id].id != 0) throw;
50     _;
51   }
52 
53   event MetaChanged(bytes32 indexed id, bytes32 indexed key, bytes32 value);
54   event OwnerChanged(bytes32 indexed id, address indexed owner);
55   event Registered(bytes32 indexed id, address indexed owner);
56   event Unregistered(bytes32 indexed id);
57 
58   mapping (bytes32 => Dapp) dapps;
59   bytes32[] ids;
60 
61   uint public fee = 1 ether;
62 
63   // returns the count of the dapps we have
64   function count() constant returns (uint) {
65     return ids.length;
66   }
67 
68   // a dapp from the list
69   function at(uint _index) constant returns (bytes32 id, address owner) {
70     Dapp d = dapps[ids[_index]];
71     id = d.id;
72     owner = d.owner;
73   }
74 
75   // get with the id
76   function get(bytes32 _id) constant returns (bytes32 id, address owner) {
77     Dapp d = dapps[_id];
78     id = d.id;
79     owner = d.owner;
80   }
81 
82   // add apps
83   function register(bytes32 _id) payable when_fee_paid when_id_free(_id) {
84     ids.push(_id);
85     dapps[_id] = Dapp(_id, msg.sender);
86     Registered(_id, msg.sender);
87   }
88 
89   // remove apps
90   function unregister(bytes32 _id) either_owner(_id) {
91     delete dapps[_id];
92     Unregistered(_id);
93   }
94 
95   // get meta information
96   function meta(bytes32 _id, bytes32 _key) constant returns (bytes32) {
97     return dapps[_id].meta[_key];
98   }
99 
100   // set meta information
101   function setMeta(bytes32 _id, bytes32 _key, bytes32 _value) only_dapp_owner(_id) {
102     dapps[_id].meta[_key] = _value;
103     MetaChanged(_id, _key, _value);
104   }
105 
106   // set the dapp owner
107   function setDappOwner(bytes32 _id, address _owner) only_dapp_owner(_id) {
108     dapps[_id].owner = _owner;
109     OwnerChanged(_id, _owner);
110   }
111 
112   // set the registration fee
113   function setFee(uint _fee) only_owner {
114     fee = _fee;
115   }
116 
117   // retrieve funds paid
118   function drain() only_owner {
119     if (!msg.sender.send(this.balance)) {
120       throw;
121     }
122   }
123 }