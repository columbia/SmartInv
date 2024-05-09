1 pragma solidity ^0.4.24;
2 
3 contract EthertipGateway {
4 
5     event Withdraw(address indexed owner, uint value);
6     event Deposit(address indexed from, uint value);   
7 
8     mapping(uint=>uint) public used;
9     address public validator;
10 
11     uint public tipToEther = 0.0001 ether;
12 
13     constructor (address _validator) public {
14         validator = _validator;
15     }    
16 
17     function () public payable {
18         emit Deposit(msg.sender, msg.value);
19     }
20 
21     function withdraw(uint _id, uint _value, bytes _sig) public {
22         bytes32 dataHash = keccak256(validator, _id, _value);
23         bytes32 prefixedHash = keccak256("\x19Ethereum Signed Message:\n32", dataHash);
24         address recovered = getRecoveredAddress(_sig, prefixedHash);
25         require(validator == recovered);
26         require(used[_id] < _value);
27         
28         uint _transfer = (_value - used[_id]) * tipToEther;
29         
30         used[_id] = _value;
31         msg.sender.transfer(_transfer);
32         emit Withdraw(msg.sender, _transfer);
33     }
34 
35     function getRecoveredAddress(bytes sig, bytes32 dataHash)
36         internal
37         pure
38         returns (address addr)
39     {
40         bytes32 ra;
41         bytes32 sa;
42         uint8 va;
43 
44         // Check the signature length
45         if (sig.length != 65) {
46           return (0);
47         }
48 
49         // Divide the signature in r, s and v variables
50         assembly {
51           ra := mload(add(sig, 32))
52           sa := mload(add(sig, 64))
53           va := byte(0, mload(add(sig, 96)))
54         }
55 
56         if (va < 27) {
57           va += 27;
58         }
59 
60         address recoveredAddress = ecrecover(dataHash, va, ra, sa);
61 
62         return (recoveredAddress);
63     }     
64 
65 }