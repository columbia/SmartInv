1 pragma solidity ^0.4.11;
2 
3 
4 //import "../zeppelin-solidity/contracts/ownership/Ownable.sol";
5 
6 contract paperCash {
7 	mapping (bytes32 => uint) grants;
8 	mapping (bytes32 => bool) claimed;
9 
10 	function createGrant(bytes32 _hashedKey)
11 		payable
12 	{
13 		require(grants[_hashedKey] == 0);
14 		require(claimed[_hashedKey] == false);
15 
16 		require(msg.value > 0);
17 		grants[_hashedKey] = msg.value;
18 
19 		LogGrantCreated(_hashedKey, msg.value);
20 	}
21 
22 	function claimGrant(bytes32 _key) 
23 	{
24 		bytes32 hashedKey = sha3(_key);
25 
26 		require(!claimed[hashedKey]);
27 		claimed[hashedKey] = true;
28 
29 		uint amount = grants[hashedKey];
30 		require(amount > 0);
31 
32 		require(msg.sender.send(amount));
33 
34 		LogGrantClaimed(hashedKey, amount);
35 	}
36 
37 	event LogGrantCreated(bytes32 hashedKey, uint amount);
38 	event LogGrantClaimed(bytes32 hashedKey, uint amount);
39 }