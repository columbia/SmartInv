1 require('@nomiclabs/hardhat-waffle');
2 require('solidity-coverage');
3 require('hardhat-gas-reporter');
4 require('hardhat-contract-sizer');
5 require('@nomiclabs/hardhat-etherscan');
6 require('dotenv').config();
7 const { DefenderRelaySigner, DefenderRelayProvider } = require('defender-relay-client/lib/ethers');
8 const rp = require('request-promise');
9 
10 const Sherlock = '0x0865a889183039689034dA55c1Fd12aF5083eabF';
11 const TWO_WEEKS = 12096e5;
12 const FOUR_HOURS_IN_SECONDS = 4 * 60 * 60;
13 
14 const ETHERSCAN_API = process.env.ETHERSCAN_API || '';
15 const ALCHEMY_API_KEY_MAINNET = process.env.ALCHEMY_API_KEY_MAINNET || '';
16 const ALCHEMY_API_KEY_GOERLI = process.env.ALCHEMY_API_KEY_GOERLI || '';
17 const PRIVATE_KEY_GOERLI = process.env.PRIVATE_KEY_GOERLI || '';
18 const PRIVATE_KEY_MAINNET = process.env.PRIVATE_KEY_MAINNET || '';
19 const RELAY_CREDENTIALS = {
20   apiKey: process.env.RELAY_API_KEY,
21   apiSecret: process.env.RELAY_API_SECRET,
22 };
23 const RELAY_PROVIDER = new DefenderRelayProvider(RELAY_CREDENTIALS);
24 const RELAY_SIGNER = new DefenderRelaySigner(RELAY_CREDENTIALS, RELAY_PROVIDER, {
25   speed: 'fast',
26   validForSeconds: FOUR_HOURS_IN_SECONDS,
27 });
28 
29 /**
30  * @type import('hardhat/config').HardhatUserConfig
31  */
32 
33 task('restake', 'Send restaking transaction').setAction(async (taskArgs) => {
34   const sherlock = await ethers.getContractAt('Sherlock', Sherlock);
35   const NOW = Date.now();
36 
37   const response = await rp({ uri: 'http://mainnet.indexer.sherlock.xyz/status', json: true });
38   if (!response['ok']) {
39     console.log('Invalid response');
40     return;
41   }
42   for (const element of response['data']['staking_positions']) {
43     // lockup_end (in milisecond) + TWO WEEKS
44     const ARB_RESTAKE = element['lockup_end'] * 1000 + TWO_WEEKS;
45     if (NOW < ARB_RESTAKE) {
46       continue;
47     }
48 
49     const result = await sherlock.viewRewardForArbRestake(element['id']);
50     if (!result[1]) {
51       console.log('Not able to restake', element['id']);
52       continue;
53     }
54 
55     console.log('restaking.. ', element['id']);
56     try {
57       await sherlock.connect(RELAY_SIGNER).arbRestake(element['id']);
58     } catch (err) {
59       console.log(err);
60     }
61   }
62 });
63 
64 module.exports = {
65   solidity: {
66     version: '0.8.10',
67     settings: {
68       optimizer: {
69         enabled: true,
70         runs: 20000,
71       },
72     },
73   },
74   networks: {
75     hardhat: {
76       accounts: {
77         mnemonic:
78           'apart turn peace asthma useful mother tank math engine usage prefer orphan exile fold squirrel',
79       },
80     },
81     localhost: {
82       timeout: 999999999,
83       gasPrice: 1600000000000,
84       //accounts: [PRIVATE_KEY].filter(item => item !== ''),
85     },
86     local: {
87       url: 'http://127.0.0.1:8545',
88       gasPrice: 500000000000,
89     },
90     mainnet: {
91       timeout: 999999999,
92       url: `https://eth-mainnet.alchemyapi.io/v2/${ALCHEMY_API_KEY_MAINNET}`,
93       gasPrice: 32000000000,
94       accounts: [PRIVATE_KEY_MAINNET].filter((item) => item !== ''),
95     },
96     goerli: {
97       url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY_GOERLI}`,
98       gasPrice: 9000000000,
99       accounts: [PRIVATE_KEY_GOERLI].filter((item) => item !== ''),
100     },
101   },
102   gasReporter: {
103     enabled: process.env.REPORT_GAS ? true : false,
104     currency: 'USD',
105     gasPrice: 100,
106     coinmarketcap: process.env.COINMARKETCAP,
107   },
108   etherscan: {
109     // Your API key for Etherscan
110     // Obtain one at https://etherscan.io/
111     apiKey: ETHERSCAN_API,
112   },
113 };
