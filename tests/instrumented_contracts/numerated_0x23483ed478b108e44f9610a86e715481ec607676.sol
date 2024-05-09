1 pragma solidity ^0.4.19;
2 
3 contract owned {
4     address public owner;
5     address public candidate;
6 
7     function owned() payable public {
8         owner = msg.sender;
9     }
10     
11     modifier onlyOwner {
12         require(owner == msg.sender);
13         _;
14     }
15     function changeOwner(address _owner) onlyOwner public {
16         candidate = _owner;
17     }
18     
19     function confirmOwner() public {
20         require(candidate == msg.sender);
21         owner = candidate;
22         delete candidate;
23     }
24 }
25 
26 contract CryptaurMigrations is owned
27 {
28     address backend;
29     modifier backendOrOwner {
30         require(backend == msg.sender || msg.sender == owner);
31         _;
32     }
33 
34     mapping(bytes => address) addressByServices;
35     mapping(address => bytes) servicesbyAddress;
36 
37     event AddService(uint dateTime, bytes serviceName, address serviceAddress);
38 
39     function CryptaurMigrations() public owned() { }
40     
41     function setBackend(address _backend) onlyOwner public {
42         backend = _backend;
43     }
44     
45     function setService(bytes serviceName, address serviceAddress) public backendOrOwner
46     {
47 		addressByServices[serviceName] = serviceAddress;
48 		servicesbyAddress[serviceAddress] = serviceName;
49 		AddService(now, serviceName, serviceAddress);
50     }
51     
52     function getServiceAddress(bytes serviceName) public view returns(address)
53     {
54 		return addressByServices[serviceName];
55     }
56 
57     function getServiceName(address serviceAddress) public view returns(bytes)
58     {
59 		return servicesbyAddress[serviceAddress];
60     }
61 }