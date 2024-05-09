1 pragma solidity ^0.4.19;
2 
3 
4 /// @title Version
5 contract Version {
6     string public semanticVersion;
7 
8     /// @notice Constructor saves a public version of the deployed Contract.
9     /// @param _version Semantic version of the contract.
10     function Version(string _version) internal {
11         semanticVersion = _version;
12     }
13 }
14 
15 
16 /// @title Factory
17 contract Factory is Version {
18     event FactoryAddedContract(address indexed _contract);
19 
20     modifier contractHasntDeployed(address _contract) {
21         require(contracts[_contract] == false);
22         _;
23     }
24 
25     mapping(address => bool) public contracts;
26 
27     function Factory(string _version) internal Version(_version) {}
28 
29     function hasBeenDeployed(address _contract) public constant returns (bool) {
30         return contracts[_contract];
31     }
32 
33     function addContract(address _contract)
34         internal
35         contractHasntDeployed(_contract)
36         returns (bool)
37     {
38         contracts[_contract] = true;
39         FactoryAddedContract(_contract);
40         return true;
41     }
42 }
43 
44 
45 contract PaymentAddress {
46     event PaymentMade(address indexed _payer, address indexed _collector, uint256 _value);
47 
48     address public collector;
49     bytes4 public identifier;
50 
51     function PaymentAddress(address _collector, bytes4 _identifier) public {
52         collector = _collector;
53         identifier = _identifier;
54     }
55 
56     function () public payable {
57         collector.transfer(msg.value);
58         PaymentMade(msg.sender, collector, msg.value);
59     }
60 }
61 
62 
63 contract PaymentAddressFactory is Factory {
64     // index of created contracts
65     mapping (bytes4 => address) public paymentAddresses;
66 
67     function PaymentAddressFactory() public Factory("1.0.0") {}
68 
69     // deploy a new contract
70     function newPaymentAddress(address _collector, bytes4 _identifier)
71         public
72         returns(address newContract)
73     {
74         require(paymentAddresses[_identifier] == address(0x0));
75         PaymentAddress paymentAddress = new PaymentAddress(_collector, _identifier);
76         paymentAddresses[_identifier] = paymentAddress;
77         addContract(paymentAddress);
78         return paymentAddress;
79     }
80 }