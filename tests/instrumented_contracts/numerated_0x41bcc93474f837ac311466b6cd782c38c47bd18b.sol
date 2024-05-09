1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 contract Certificate is Ownable {
39 
40   event LogAddCertificateAuthority(address indexed ca_address);
41   event LogRemoveCertificateAuthority(address indexed ca_address);
42   event LogAddCertificate(address indexed ca_address, bytes32 certificate_hash);
43   event LogRevokeCertificate(address indexed ca_address, bytes32 certificate_hash);
44   event LogBindCertificate2Wallet(address indexed ca_address, bytes32 certificate_hash, address indexed wallet);
45 
46   struct CertificateAuthority {
47     string lookup_api;
48     string organization;
49     string common_name;
50     string country;
51     string province;
52     string locality;
53   }
54 
55   struct CertificateMeta {
56     address ca_address;
57     uint256 expires;
58     bytes32 sealed_hash;
59     bytes32 certificate_hash;
60   }
61 
62   // Mapping of certificate authority address to the certificate authority
63   mapping(address => CertificateAuthority) private certificate_authority;
64 
65   // Mapping of Ethereum wallet address to mapping of certificate authority address to wallet certificate hash
66   mapping(address => mapping(address => bytes32)) private wallet_authority_certificate;
67 
68   // Mapping of wallet certificate hash to wallet certificate meta data
69   mapping(bytes32 => CertificateMeta) private certificates;
70 
71   modifier onlyCA() {
72     require(bytes(certificate_authority[msg.sender].lookup_api).length != 0);
73     _;
74   }
75 
76   /// @dev Adds a new approved certificate authority
77   /// @param ca_address Address of certificate authority to add
78   /// @param lookup_api certificate lookup API for the given authority
79   /// @param organization Name of the organization this certificate authority represents
80   /// @param common_name Common name of this certificate authority
81   /// @param country Certificate authority jurisdiction country
82   /// @param province Certificate authority jurisdiction state/province
83   /// @param locality Certificate authority jurisdiction locality
84   function addCA(
85     address ca_address,
86     string lookup_api,
87     string organization,
88     string common_name,
89     string country,
90     string province,
91     string locality
92   ) public onlyOwner {
93     require (ca_address != 0x0);
94     require (ca_address != msg.sender);
95     require (bytes(lookup_api).length != 0);
96     require (bytes(organization).length > 3);
97     require (bytes(common_name).length > 3);
98     require (bytes(country).length > 1);
99 
100     certificate_authority[ca_address] = CertificateAuthority(
101       lookup_api,
102       organization,
103       common_name,
104       country,
105       province,
106       locality
107     );
108     LogAddCertificateAuthority(ca_address);
109   }
110 
111   /// @dev Removes an existing certificate authority, preventing it from issuing new certificates
112   /// @param ca_address Address of certificate authority to remove
113   function removeCA(address ca_address) public onlyOwner {
114     delete certificate_authority[ca_address];
115     LogRemoveCertificateAuthority(ca_address);
116   }
117 
118   /// @dev Checks whether an address represents a certificate authority
119   /// @param ca_address Address to check
120   /// @return true if the address is a valid certificate authority; false otherwise
121   function isCA(address ca_address) public view returns (bool) {
122     return bytes(certificate_authority[ca_address].lookup_api).length != 0;
123   }
124 
125   /// @dev Returns the certificate lookup API for the certificate authority
126   /// @param ca_address Address of certificate authority
127   /// @return lookup api, organization name, common name, country, state/province, and locality of the certificate authority
128   function getCA(address ca_address) public view returns (string, string, string, string, string, string) {
129     CertificateAuthority storage ca = certificate_authority[ca_address];
130     return (ca.lookup_api, ca.organization, ca.common_name, ca.country, ca.province, ca.locality);
131   }
132 
133   /// @dev Adds a new certificate by the calling certificate authority
134   /// @param expires seconds from epoch until certificate expires
135   /// @param sealed_hash hash of sealed portion of the certificate
136   /// @param certificate_hash hash of public portion of the certificate
137   function addNewCertificate(uint256 expires, bytes32 sealed_hash, bytes32 certificate_hash) public onlyCA {
138     require(expires > now);
139 
140     CertificateMeta storage cert = certificates[certificate_hash];
141     require(cert.expires == 0);
142 
143     certificates[certificate_hash] = CertificateMeta(msg.sender, expires, sealed_hash, certificate_hash);
144     LogAddCertificate(msg.sender, certificate_hash);
145   }
146 
147   /// @dev Adds a new certificate by the calling certificate authority and binds to given wallet
148   /// @param wallet Wallet to which the certificate is being bound to
149   /// @param expires seconds from epoch until certificate expires
150   /// @param sealed_hash hash of sealed portion of the certificate
151   /// @param certificate_hash hash of public portion of the certificate
152   function addCertificateAndBind2Wallet(address wallet, uint256 expires, bytes32 sealed_hash, bytes32 certificate_hash) public onlyCA {
153     require(expires > now);
154 
155     CertificateMeta storage cert = certificates[certificate_hash];
156     require(cert.expires == 0);
157 
158     certificates[certificate_hash] = CertificateMeta(msg.sender, expires, sealed_hash, certificate_hash);
159     LogAddCertificate(msg.sender, certificate_hash);
160     wallet_authority_certificate[wallet][msg.sender] = certificate_hash;
161     LogBindCertificate2Wallet(msg.sender, certificate_hash, wallet);
162   }
163 
164   /// @dev Bind an existing certificate to a wallet - can be called by certificate authority that issued the certificate or a wallet already bound to the certificate
165   /// @param wallet Wallet to which the certificate is being bound to
166   /// @param certificate_hash hash of public portion of the certificate
167   function bindCertificate2Wallet(address wallet, bytes32 certificate_hash) public {
168     CertificateMeta storage cert = certificates[certificate_hash];
169     require(cert.expires > now);
170 
171     bytes32 sender_certificate_hash = wallet_authority_certificate[msg.sender][cert.ca_address];
172 
173     require(cert.ca_address == msg.sender || cert.certificate_hash == sender_certificate_hash);
174 
175     wallet_authority_certificate[wallet][cert.ca_address] = certificate_hash;
176     LogBindCertificate2Wallet(msg.sender, certificate_hash, wallet);
177   }
178 
179   /// @dev Revokes an existing certificate - can be called by certificate authority that issued the certificate
180   /// @param certificate_hash hash of public portion of the certificate
181   function revokeCertificate(bytes32 certificate_hash) public onlyCA {
182     CertificateMeta storage cert = certificates[certificate_hash];
183     require(cert.ca_address == msg.sender);
184     cert.expires = 0;
185     LogRevokeCertificate(msg.sender, certificate_hash);
186   }
187 
188   /// @dev returns certificate metadata given the certificate hash
189   /// @param certificate_hash hash of public portion of the certificate
190   /// @return certificate authority address, certificate expiration time, hash of sealed portion of the certificate, hash of public portion of the certificate
191   function getCertificate(bytes32 certificate_hash) public view returns (address, uint256, bytes32, bytes32) {
192     CertificateMeta storage cert = certificates[certificate_hash];
193     if (isCA(cert.ca_address)) {
194       return (cert.ca_address, cert.expires, cert.sealed_hash, cert.certificate_hash);
195     } else {
196       return (0x0, 0, 0x0, 0x0);
197     }
198   }
199 
200   /// @dev returns certificate metadata for a given wallet from a particular certificate authority
201   /// @param wallet Wallet for which the certificate is being looked up
202   /// @param ca_address Address of certificate authority
203   /// @return certificate expiration time, hash of sealed portion of the certificate, hash of public portion of the certificate
204   function getCertificateForWallet(address wallet, address ca_address) public view returns (uint256, bytes32, bytes32) {
205     bytes32 certificate_hash = wallet_authority_certificate[wallet][ca_address];
206     CertificateMeta storage cert = certificates[certificate_hash];
207     if (isCA(cert.ca_address)) {
208       return (cert.expires, cert.sealed_hash, cert.certificate_hash);
209     } else {
210       return (0, 0x0, 0x0);
211     }
212   }
213 }