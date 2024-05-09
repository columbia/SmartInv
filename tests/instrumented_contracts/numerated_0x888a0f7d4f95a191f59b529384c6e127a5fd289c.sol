1 pragma solidity 0.4.25;
2 
3 contract EthertipGateway {
4 
5     event Withdraw(address indexed owner, uint value);
6     event Deposit(address indexed from, uint value);   
7 
8     mapping(string=>uint) internal used;
9     mapping(string=>address) internal users;
10 
11     address public validator;
12     uint public tipToEther = 0.0001 ether;
13 
14     constructor (address _validator) public {
15         validator = _validator;
16     }    
17 
18     function () public payable {
19         emit Deposit(msg.sender, msg.value);
20     }
21     
22     function getUsed(string _id) public returns (uint) {
23         return used[_id];            
24     }
25     
26     function getUser(string _id) public returns (address) {
27         return users[_id];
28     }    
29 
30     function register(string _id, address _address) public {
31         require(msg.sender == validator);
32         users[_id] = _address;
33     }
34 
35     function withdraw(string _id, uint _value, bytes _sig) public {
36         bytes32 dataHash = keccak256(validator, _id, _value);
37         bytes32 prefixedHash = keccak256("\x19Ethereum Signed Message:\n32", dataHash);
38         address recovered = getRecoveredAddress(_sig, prefixedHash);
39         require(validator == recovered);
40         require(users[_id] == msg.sender);
41         require(used[_id] < _value);
42         
43         uint _transfer = (_value - used[_id]) * tipToEther;
44         
45         used[_id] = _value;
46         msg.sender.transfer(_transfer);
47         emit Withdraw(msg.sender, _transfer);
48     }
49 
50     function getRecoveredAddress(bytes sig, bytes32 dataHash)
51         internal
52         pure
53         returns (address addr)
54     {
55         bytes32 ra;
56         bytes32 sa;
57         uint8 va;
58 
59         // Check the signature length
60         if (sig.length != 65) {
61           return (0);
62         }
63 
64         // Divide the signature in r, s and v variables
65         assembly {
66           ra := mload(add(sig, 32))
67           sa := mload(add(sig, 64))
68           va := byte(0, mload(add(sig, 96)))
69         }
70 
71         if (va < 27) {
72           va += 27;
73         }
74 
75         address recoveredAddress = ecrecover(dataHash, va, ra, sa);
76         return (recoveredAddress);
77     }     
78     
79 }