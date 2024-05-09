1 pragma solidity ^0.4.2;
2 /**
3  * @title Contract for object that have an owner
4  */
5 contract Owned {
6     /**
7      * Contract owner address
8      */
9     address public owner;
10 
11     /**
12      * @dev Store owner on creation
13      */
14     function Owned() { owner = msg.sender; }
15 
16     /**
17      * @dev Delegate contract to another person
18      * @param _owner is another person address
19      */
20     function delegate(address _owner) onlyOwner
21     { owner = _owner; }
22 
23     /**
24      * @dev Owner check modifier
25      */
26     modifier onlyOwner { if (msg.sender != owner) throw; _; }
27 }
28 /**
29  * @title Contract for objects that can be morder
30  */
31 contract Mortal is Owned {
32     /**
33      * @dev Destroy contract and scrub a data
34      * @notice Only owner can kill me
35      */
36     function kill() onlyOwner
37     { suicide(owner); }
38 }
39 //sol Registrar
40 // Simple global registrar.
41 // @authors:
42 //   Gav Wood <g@ethdev.com>
43 contract Registrar {
44 	event Changed(string indexed name);
45 
46 	function owner(string _name) constant returns (address o_owner);
47 	function addr(string _name) constant returns (address o_address);
48 	function subRegistrar(string _name) constant returns (address o_subRegistrar);
49 	function content(string _name) constant returns (bytes32 o_content);
50 }
51 //sol OwnedRegistrar
52 // Global registrar with single authoritative owner.
53 // @authors:
54 //   Gav Wood <g@ethdev.com>
55 contract AiraRegistrarService is Registrar, Mortal {
56 	struct Record {
57 		address addr;
58 		address subRegistrar;
59 		bytes32 content;
60 	}
61 	
62     function owner(string _name) constant returns (address o_owner)
63     { return 0; }
64 
65 	function disown(string _name) onlyOwner {
66 		delete m_toRecord[_name];
67 		Changed(_name);
68 	}
69 
70 	function setAddr(string _name, address _a) onlyOwner {
71 		m_toRecord[_name].addr = _a;
72 		Changed(_name);
73 	}
74 	function setSubRegistrar(string _name, address _registrar) onlyOwner {
75 		m_toRecord[_name].subRegistrar = _registrar;
76 		Changed(_name);
77 	}
78 	function setContent(string _name, bytes32 _content) onlyOwner {
79 		m_toRecord[_name].content = _content;
80 		Changed(_name);
81 	}
82 	function record(string _name) constant returns (address o_addr, address o_subRegistrar, bytes32 o_content) {
83 		o_addr = m_toRecord[_name].addr;
84 		o_subRegistrar = m_toRecord[_name].subRegistrar;
85 		o_content = m_toRecord[_name].content;
86 	}
87 	function addr(string _name) constant returns (address) { return m_toRecord[_name].addr; }
88 	function subRegistrar(string _name) constant returns (address) { return m_toRecord[_name].subRegistrar; }
89 	function content(string _name) constant returns (bytes32) { return m_toRecord[_name].content; }
90 
91 	mapping (string => Record) m_toRecord;
92 }