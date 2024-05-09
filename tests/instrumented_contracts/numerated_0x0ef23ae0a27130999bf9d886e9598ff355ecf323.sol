1 pragma solidity ^0.4.20;
2 
3 
4 contract Voucher {
5 
6     bytes32 private token;
7     address private owner;
8     uint private created_at;
9     uint private updated_at;
10     uint private expires_at;
11     /** in days **/
12     bool private burnt;
13 
14     /**
15      * Constructor
16      */
17     constructor(bytes32 voucher_token, uint _lifetime) public {
18         token = voucher_token;
19         burnt = false;
20         created_at = now;
21         updated_at = now;
22         expires_at = created_at + (_lifetime * 60*60*24);
23         owner = msg.sender;
24     }
25 
26     /**
27      * Burn a Voucher
28      */
29     function burn(bytes32 voucher_token) public returns (bool success){
30         require(token == voucher_token, "Forbidden.");
31         require(msg.sender == owner);
32         require(!burnt, "Already burnt.");
33         burnt = true;
34         updated_at = now;
35         return true;
36     }
37 
38     function is_burnt(bytes32 voucher_token) public returns (bool) {
39         require(token == voucher_token, "Forbidden.");
40         require(msg.sender == owner);
41         if (is_expired(voucher_token)){
42             burn(voucher_token);
43         }
44         return burnt;
45     }
46 
47     function is_expired(bytes32 voucher_token) view public returns(bool){
48         require(token == voucher_token, "Forbidden.");
49         return expires_at != created_at && expires_at < now;
50     }
51 }