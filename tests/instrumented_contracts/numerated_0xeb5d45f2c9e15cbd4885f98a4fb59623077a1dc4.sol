1 pragma solidity ^0.5.9;
2 
3 contract ImmDomains {
4 
5   address public owner;
6   address public registrar;
7 
8   mapping(bytes => address) public addresses;
9 
10   event OwnerUpdate(address _owner);
11   event RegistrarUpdate(address _registrar);
12   event Registration(bytes _domain, address _address);
13 
14   constructor() public {
15     owner = msg.sender;
16     registrar = msg.sender;
17   }
18 
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24   function setOwner(address _owner) onlyOwner() external {
25     owner = _owner;
26     emit OwnerUpdate(_owner);
27   }
28 
29   function setRegistrar(address _registrar) onlyOwner() external {
30     registrar = _registrar;
31     emit RegistrarUpdate(_registrar);
32   }
33 
34   function isValidCharacter(uint8 _character) public pure returns (bool) {
35     if (_character >= 97 && _character <= 122) {
36       // ASCII "a - z"
37       return true;
38     }
39     if (_character >= 48 && _character <= 57) {
40       // ASCII "0 - 9"
41       return true;
42     }
43     return false;
44   }
45 
46   function isValidDomain(bytes memory _domain) public pure returns (bool) {
47     if(_domain.length == 0) {
48       return false;
49     }
50 
51     for (uint i; i < _domain.length; i++) {
52       if(isValidCharacter(uint8(_domain[i])) == false) {
53         return false;
54       }
55     }
56 
57     return true;
58   }
59 
60   function register(bytes calldata _domain, address _address) external {
61 
62     require(msg.sender == registrar);
63     require(_address != address(0));
64     require(isValidDomain(_domain));
65     require(addresses[_domain] == address(0));
66 
67     addresses[_domain] = _address;
68     emit Registration(_domain, _address);
69 
70   }
71 
72 }