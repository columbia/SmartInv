1 /*
2  * This contract is a registry which maps the Ethereum Address to their
3  *  endpoint i.e sockets.
4  * The Ethereum address registers his address in this registry.
5  * @proofsuite was here testing on the mainnet
6 */
7 
8 pragma solidity ^0.4.11;
9 
10 contract EndpointRegistry{
11     string constant public contract_version = "0.2._";
12 
13     event AddressRegistered(address indexed eth_address, string socket);
14 
15     // Mapping of Ethereum Addresses => SocketEndpoints
16     mapping (address => string) address_to_socket;
17     // Mapping of SocketEndpoints => Ethereum Addresses
18     mapping (string => address) socket_to_address;
19     // list of all the Registered Addresses , still not used.
20     address[] eth_addresses;
21 
22     modifier noEmptyString(string str)
23     {
24         require(equals(str, "") != true);
25         _;
26     }
27 
28     /*
29      * @notice Registers the Ethereum Address to the Endpoint socket.
30      * @dev Registers the Ethereum Address to the Endpoint socket.
31      * @param string of socket in this format "127.0.0.1:40001"
32      */
33     function registerEndpoint(string socket)
34         public
35         noEmptyString(socket)
36     {
37         string storage old_socket = address_to_socket[msg.sender];
38 
39         // Compare if the new socket matches the old one, if it does just return
40         if (equals(old_socket, socket)) {
41             return;
42         }
43 
44         // Put the ethereum address 0 in front of the old_socket,old_socket:0x0
45         socket_to_address[old_socket] = address(0);
46         address_to_socket[msg.sender] = socket;
47         socket_to_address[socket] = msg.sender;
48         AddressRegistered(msg.sender, socket);
49     }
50 
51     /*
52      * @notice Finds the socket if given an Ethereum Address
53      * @dev Finds the socket if given an Ethereum Address
54      * @param An eth_address which is a 20 byte Ethereum Address
55      * @return A socket which the current Ethereum Address is using.
56      */
57     function findEndpointByAddress(address eth_address) public constant returns (string socket)
58     {
59         return address_to_socket[eth_address];
60     }
61 
62     /*
63      * @notice Finds Ethreum Address if given an existing socket address
64      * @dev Finds Ethreum Address if given an existing socket address
65      * @param string of socket in this format "127.0.0.1:40001"
66      * @return An ethereum address
67      */
68     function findAddressByEndpoint(string socket) public constant returns (address eth_address)
69     {
70         return socket_to_address[socket];
71     }
72 
73     function equals(string a, string b) internal pure returns (bool result)
74     {
75         if (keccak256(a) == keccak256(b)) {
76             return true;
77         }
78 
79         return false;
80     }
81 }