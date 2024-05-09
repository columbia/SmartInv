1 pragma solidity 0.4.24;
2 
3 // File: contracts/Users.sol
4 
5 contract Users {
6     struct Entry {
7         uint keyIndex;
8         string value;
9     }
10 
11     struct AddressStringMap {
12         mapping(address => Entry) data;
13         address[] keys;
14     }
15 
16     AddressStringMap internal usernames;
17 
18     function putUsername(string _username)
19         public
20         returns (bool)
21     {
22         address senderAddress = msg.sender;
23         Entry storage entry = usernames.data[senderAddress];
24         entry.value = _username;
25         if (entry.keyIndex > 0) {
26             return true;
27         } else {
28             entry.keyIndex = ++usernames.keys.length;
29             usernames.keys[entry.keyIndex - 1] = senderAddress;
30             return false;
31         }
32     }
33 
34     function removeUsername()
35         public
36         returns (bool)
37     {
38         address senderAddress = msg.sender;
39         Entry storage entry = usernames.data[senderAddress];
40         if (entry.keyIndex == 0) {
41             return false;
42         }
43 
44         if (entry.keyIndex <= usernames.keys.length) {
45             // Move an existing element into the vacated key slot.
46             usernames.data[usernames.keys[usernames.keys.length - 1]].keyIndex = entry.keyIndex;
47             usernames.keys[entry.keyIndex - 1] = usernames.keys[usernames.keys.length - 1];
48             usernames.keys.length -= 1;
49             delete usernames.data[senderAddress];
50             return true;
51         }
52     }
53 
54     function size()
55         public
56         view
57         returns (uint)
58     {
59         return usernames.keys.length;
60     }
61 
62     function getUsernameByAddress(address _address)
63         public
64         constant
65         returns (string)
66     {
67         return usernames.data[_address].value;
68     }
69 
70     function getAddressByIndex(uint idx)
71         public
72         constant
73         returns (address)
74     {
75         return usernames.keys[idx];
76     }
77 
78     function getUsernameByIndex(uint idx)
79         public
80         constant
81         returns (string)
82     {
83         return usernames.data[usernames.keys[idx]].value;
84     }
85 }