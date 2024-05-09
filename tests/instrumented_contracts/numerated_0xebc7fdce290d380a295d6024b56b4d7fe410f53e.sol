1 pragma solidity ^0.4.2;
2 contract Owned {
3     address public owner;
4     function Owned() { owner = msg.sender; }
5     function delegate(address _owner) onlyOwner
6     { owner = _owner; }
7     modifier onlyOwner { if (msg.sender != owner) throw; _; }
8 }
9 contract Mortal is Owned {
10     function kill() onlyOwner
11     { suicide(owner); }
12 }
13 contract Registrar {
14 	event Changed(string indexed name);
15 
16 	function owner(string _name) constant returns (address o_owner);
17 	function addr(string _name) constant returns (address o_address);
18 	function subRegistrar(string _name) constant returns (address o_subRegistrar);
19 	function content(string _name) constant returns (bytes32 o_content);
20 }
21 contract AiraRegistrarService is Registrar, Mortal {
22 	struct Record {
23 		address addr;
24 		address subRegistrar;
25 		bytes32 content;
26 	}
27 	
28     function owner(string _name) constant returns (address o_owner)
29     { return 0; }
30 
31 	function disown(string _name) onlyOwner {
32 		delete m_toRecord[_name];
33 		Changed(_name);
34 	}
35 
36 	function setAddr(string _name, address _a) onlyOwner {
37 		m_toRecord[_name].addr = _a;
38 		Changed(_name);
39 	}
40 	function setSubRegistrar(string _name, address _registrar) onlyOwner {
41 		m_toRecord[_name].subRegistrar = _registrar;
42 		Changed(_name);
43 	}
44 	function setContent(string _name, bytes32 _content) onlyOwner {
45 		m_toRecord[_name].content = _content;
46 		Changed(_name);
47 	}
48 	function record(string _name) constant returns (address o_addr, address o_subRegistrar, bytes32 o_content) {
49 		o_addr = m_toRecord[_name].addr;
50 		o_subRegistrar = m_toRecord[_name].subRegistrar;
51 		o_content = m_toRecord[_name].content;
52 	}
53 	function addr(string _name) constant returns (address) { return m_toRecord[_name].addr; }
54 	function subRegistrar(string _name) constant returns (address) { return m_toRecord[_name].subRegistrar; }
55 	function content(string _name) constant returns (bytes32) { return m_toRecord[_name].content; }
56 
57 	mapping (string => Record) m_toRecord;
58 }