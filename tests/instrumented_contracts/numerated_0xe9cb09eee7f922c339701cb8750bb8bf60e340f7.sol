1 pragma solidity ^0.4.18;
2 
3 contract Profile {
4   mapping (address => string) private usernameOfOwner;
5   mapping (address => string) private agendaOfOwner;
6   mapping (string => address) private ownerOfUsername;
7 
8   event Set (string indexed _username, string indexed _agenda, address indexed _owner);
9   event SetUsername (string indexed _username, address indexed _owner);
10   event SetAgenda (string indexed _agenda, address indexed _owner);
11   event Unset (string indexed _username, string indexed _agenda, address indexed _owner);
12   event UnsetUsername(string indexed _username, address indexed _owner);
13   event UnsetAgenda(string indexed _agenda, address indexed _owner);
14 
15 
16   function Profile () public {
17   }
18 
19   function usernameOf (address _owner) public view returns (string _username) {
20     return usernameOfOwner[_owner];
21   }
22 
23   function agendaOf (address _owner) public view returns (string _agenda) {
24     return agendaOfOwner[_owner];
25   }
26 
27   function getUserValues(address _owner) public view returns (string _username, string _agenda){
28     return (usernameOfOwner[_owner], agendaOfOwner[_owner]);
29   }
30 
31   function ownerOf (string _username) public view returns (address _owner) {
32     return ownerOfUsername[_username];
33   }
34 
35   function set (string _username, string _agenda) public {
36     require(bytes(_username).length > 2);
37     require(bytes(_agenda).length > 2);
38     require(ownerOf(_username) == address(0) || ownerOf(_username) == msg.sender);
39     address owner = msg.sender;
40     string storage oldUsername = usernameOfOwner[owner];
41     string storage oldAgenda = agendaOfOwner[owner];
42     if (bytes(oldUsername).length > 0 && bytes(oldAgenda).length > 0) {
43       Unset(oldUsername, oldAgenda, owner);
44       delete ownerOfUsername[oldUsername];
45     }
46     usernameOfOwner[owner] = _username;
47     agendaOfOwner[owner] = _agenda;
48     ownerOfUsername[_username] = owner;
49     Set(_username, _agenda, owner);
50   }
51 
52   function setUsername (string _username) public {
53     require(bytes(_username).length > 2);
54     require(ownerOf(_username) == address(0) || ownerOf(_username) == msg.sender);
55     address owner = msg.sender;
56     string storage oldUsername = usernameOfOwner[owner];
57     if(bytes(oldUsername).length > 0) {
58       UnsetUsername(oldUsername, owner);
59       delete ownerOfUsername[oldUsername];
60     }
61     usernameOfOwner[owner] = _username;
62     ownerOfUsername[_username] = owner;
63     SetUsername(_username, owner);
64   }
65 
66   function setAgenda (string _agenda) public {
67     require(bytes(_agenda).length > 2);
68     address owner = msg.sender;
69     string storage oldAgenda = agendaOfOwner[owner];
70     if(bytes(oldAgenda).length > 0) {
71       UnsetAgenda(oldAgenda, owner);
72     }
73     agendaOfOwner[owner] = _agenda;
74     SetUsername(_agenda, owner);
75   }
76 
77   function unset () public {
78     require(bytes(usernameOfOwner[msg.sender]).length > 0 && bytes(agendaOfOwner[msg.sender]).length > 0);
79     address owner = msg.sender;
80     string storage oldUsername = usernameOfOwner[owner];
81     string storage oldAgenda = agendaOfOwner[owner];
82     Unset(oldUsername, oldAgenda, owner);
83     delete ownerOfUsername[oldUsername];
84     delete usernameOfOwner[owner];
85     delete agendaOfOwner[owner];
86   }
87 }