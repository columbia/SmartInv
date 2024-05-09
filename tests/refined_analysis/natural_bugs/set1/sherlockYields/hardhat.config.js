require('@nomiclabs/hardhat-waffle');
require('solidity-coverage');
require('hardhat-gas-reporter');
require('hardhat-contract-sizer');
require('@nomiclabs/hardhat-etherscan');
require('dotenv').config();
const { DefenderRelaySigner, DefenderRelayProvider } = require('defender-relay-client/lib/ethers');
const rp = require('request-promise');

const Sherlock = '0x0865a889183039689034dA55c1Fd12aF5083eabF';
const TWO_WEEKS = 12096e5;
const FOUR_HOURS_IN_SECONDS = 4 * 60 * 60;

const ETHERSCAN_API = process.env.ETHERSCAN_API || '';
const ALCHEMY_API_KEY_MAINNET = process.env.ALCHEMY_API_KEY_MAINNET || '';
const ALCHEMY_API_KEY_GOERLI = process.env.ALCHEMY_API_KEY_GOERLI || '';
const PRIVATE_KEY_GOERLI = process.env.PRIVATE_KEY_GOERLI || '';
const PRIVATE_KEY_MAINNET = process.env.PRIVATE_KEY_MAINNET || '';
const RELAY_CREDENTIALS = {
  apiKey: process.env.RELAY_API_KEY,
  apiSecret: process.env.RELAY_API_SECRET,
};
const RELAY_PROVIDER = new DefenderRelayProvider(RELAY_CREDENTIALS);
const RELAY_SIGNER = new DefenderRelaySigner(RELAY_CREDENTIALS, RELAY_PROVIDER, {
  speed: 'fast',
  validForSeconds: FOUR_HOURS_IN_SECONDS,
});

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

task('restake', 'Send restaking transaction').setAction(async (taskArgs) => {
  const sherlock = await ethers.getContractAt('Sherlock', Sherlock);
  const NOW = Date.now();

  const response = await rp({ uri: 'http://mainnet.indexer.sherlock.xyz/status', json: true });
  if (!response['ok']) {
    console.log('Invalid response');
    return;
  }
  for (const element of response['data']['staking_positions']) {
    // lockup_end (in milisecond) + TWO WEEKS
    const ARB_RESTAKE = element['lockup_end'] * 1000 + TWO_WEEKS;
    if (NOW < ARB_RESTAKE) {
      continue;
    }

    const result = await sherlock.viewRewardForArbRestake(element['id']);
    if (!result[1]) {
      console.log('Not able to restake', element['id']);
      continue;
    }

    console.log('restaking.. ', element['id']);
    try {
      await sherlock.connect(RELAY_SIGNER).arbRestake(element['id']);
    } catch (err) {
      console.log(err);
    }
  }
});

module.exports = {
  solidity: {
    version: '0.8.10',
    settings: {
      optimizer: {
        enabled: true,
        runs: 20000,
      },
    },
  },
  networks: {
    hardhat: {
      accounts: {
        mnemonic:
          'apart turn peace asthma useful mother tank math engine usage prefer orphan exile fold squirrel',
      },
    },
    localhost: {
      timeout: 999999999,
      gasPrice: 1600000000000,
      //accounts: [PRIVATE_KEY].filter(item => item !== ''),
    },
    local: {
      url: 'http://127.0.0.1:8545',
      gasPrice: 500000000000,
    },
    mainnet: {
      timeout: 999999999,
      url: `https://eth-mainnet.alchemyapi.io/v2/${ALCHEMY_API_KEY_MAINNET}`,
      gasPrice: 32000000000,
      accounts: [PRIVATE_KEY_MAINNET].filter((item) => item !== ''),
    },
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY_GOERLI}`,
      gasPrice: 9000000000,
      accounts: [PRIVATE_KEY_GOERLI].filter((item) => item !== ''),
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS ? true : false,
    currency: 'USD',
    gasPrice: 100,
    coinmarketcap: process.env.COINMARKETCAP,
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: ETHERSCAN_API,
  },
};
