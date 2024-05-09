1 pragma solidity ^0.4.24;
2 
3 contract EthertipGateway {
4 
5     event Withdraw(address indexed owner, uint value);
6     event Deposit(address indexed from, uint value);   
7 
8     mapping(uint=>uint) public used;
9     mapping(uint=>address) public users;
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
22     function register(uint _id, address _address) public {
23         require(msg.sender == validator);
24         users[_id] = _address;
25     }
26 
27     function withdraw(uint _id, uint _value, bytes _sig) public {
28         bytes32 dataHash = keccak256(validator, _id, _value);
29         bytes32 prefixedHash = keccak256("\x19Ethereum Signed Message:\n32", dataHash);
30         address recovered = getRecoveredAddress(_sig, prefixedHash);
31         require(validator == recovered);
32         require(users[_id] == msg.sender);
33         require(used[_id] < _value);
34         
35         uint _transfer = (_value - used[_id]) * tipToEther;
36         
37         used[_id] = _value;
38         msg.sender.transfer(_transfer);
39         emit Withdraw(msg.sender, _transfer);
40     }
41 
42     function getRecoveredAddress(bytes sig, bytes32 dataHash)
43         internal
44         pure
45         returns (address addr)
46     {
47         bytes32 ra;
48         bytes32 sa;
49         uint8 va;
50 
51         // Check the signature length
52         if (sig.length != 65) {
53           return (0);
54         }
55 
56         // Divide the signature in r, s and v variables
57         assembly {
58           ra := mload(add(sig, 32))
59           sa := mload(add(sig, 64))
60           va := byte(0, mload(add(sig, 96)))
61         }
62 
63         if (va < 27) {
64           va += 27;
65         }
66 
67         address recoveredAddress = ecrecover(dataHash, va, ra, sa);
68 
69         return (recoveredAddress);
70     }     
71 
72 }