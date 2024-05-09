1 pragma solidity ^0.4.14;
2 
3 contract Owned
4 {
5     address public owner;
6     
7     function Owned()
8     {
9         owner = msg.sender;
10     }
11     
12     modifier onlyOwner()
13     {
14         if (msg.sender != owner) revert();
15         _;
16     }
17 }
18 
19 contract ProspectorsDevAllocation is Owned
20 {
21     ProspectorsGoldToken public token;
22     uint public initial_time;
23 
24     mapping(uint => bool) public unlocked;
25     mapping(uint => uint) public unlock_times;
26     mapping(uint => uint) unlock_values;
27     
28     //contract with PGL tokens for Prospectors developers. Tokens will be frozen up to 4 years
29     function ProspectorsDevAllocation(address _token)
30     {
31         token = ProspectorsGoldToken(_token);
32     }
33     
34     function init() onlyOwner
35     {
36         if (token.balanceOf(this) == 0 || initial_time != 0) revert();
37         initial_time = block.timestamp;
38         uint unlock_amount = token.balanceOf(this) / 5; //one part - 20% of tokens
39 
40         unlock_values[0] = unlock_amount;
41         unlock_values[1] = unlock_amount;
42         unlock_values[2] = unlock_amount;
43         unlock_values[3] = unlock_amount;
44         unlock_values[4] = unlock_amount;
45         
46         unlock_times[0] = 180 days; //20% of tokens will be available after 180 days
47         unlock_times[1] = 360 days; //20% of tokens will be available after 360 days
48         unlock_times[2] = 720 days; //20% of tokens will be available after 2 years
49         unlock_times[3] = 1080 days; //20% of tokens will be available after 3 years
50         unlock_times[4] = 1440 days; //20% of tokens will be available after 4 years
51     }
52 
53     function unlock(uint part)
54     {
55         if (unlocked[part] == true || block.timestamp < initial_time + unlock_times[part] || unlock_values[part] == 0) revert();
56         token.transfer(owner, unlock_values[part]);
57         unlocked[part] = true;
58     }
59 }
60 
61 contract ProspectorsGoldToken {
62     function balanceOf( address who ) constant returns (uint value);
63     function transfer( address to, uint value) returns (bool ok);
64 }