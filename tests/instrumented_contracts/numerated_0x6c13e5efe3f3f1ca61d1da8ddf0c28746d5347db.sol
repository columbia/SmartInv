1 pragma solidity ^0.4.2;
2 
3 
4 contract DataPost{
5 
6     function () {
7         //if ether is sent to this address, send it back.
8         throw;
9     }
10     event dataPosted(
11     	address poster,
12     	string data,
13     	string hash_algorithm,
14     	string signature,
15     	string signature_spec
16     );
17   	function postData(string data, string hash_algorithm,string signature,string signature_spec){
18   		emit dataPosted(msg.sender,data,hash_algorithm,signature,signature_spec);
19   	}
20    
21 }