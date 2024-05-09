1 //! A decentralised registry of 4-bytes signatures => method mappings
2 //! By Parity Team (Ethcore), 2016.
3 //! Released under the Apache Licence 2.
4 
5 pragma solidity ^0.4.1;
6 
7 contract Owned {
8   modifier only_owner {
9     if (msg.sender != owner) return;
10     _;
11   }
12 
13   event NewOwner(address indexed old, address indexed current);
14 
15   function setOwner(address _new) only_owner { NewOwner(owner, _new); owner = _new; }
16 
17   address public owner = msg.sender;
18 }
19 
20 contract SignatureReg is Owned {
21   // mapping of signatures to entries
22   mapping (bytes4 => string) public entries;
23 
24   // the total count of registered signatures
25   uint public totalSignatures = 0;
26 
27   // allow only new calls to go in
28   modifier when_unregistered(bytes4 _signature) {
29     if (bytes(entries[_signature]).length != 0) return;
30     _;
31   }
32 
33   // dispatched when a new signature is registered
34   event Registered(address indexed creator, bytes4 indexed signature, string method);
35 
36   // constructor with self-registration
37   function SignatureReg() {
38     register('register(string)');
39   }
40 
41   // registers a method mapping
42   function register(string _method) returns (bool) {
43     return _register(bytes4(sha3(_method)), _method);
44   }
45 
46   // internal register function, signature => method
47   function _register(bytes4 _signature, string _method) internal when_unregistered(_signature) returns (bool) {
48     entries[_signature] = _method;
49     totalSignatures = totalSignatures + 1;
50     Registered(msg.sender, _signature, _method);
51     return true;
52   }
53 
54   // in the case of any extra funds
55   function drain() only_owner {
56     if (!msg.sender.send(this.balance)) {
57       throw;
58     }
59   }
60 }