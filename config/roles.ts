import { HardhatRuntimeEnvironment } from "hardhat/types";

export type RolesConfig = {
  account: string;
  roles: string[];
}[];

export default async function (hre: HardhatRuntimeEnvironment): Promise<RolesConfig> {
  const { deployer } = await hre.getNamedAccounts();
  const config: {
    [network: string]: RolesConfig;
  } = {
    hardhat: [
      {
        account: deployer,
        roles: [
          "CONTROLLER",
          "ORDER_KEEPER",
          "ADL_KEEPER",
          "LIQUIDATION_KEEPER",
          "MARKET_KEEPER",
          "FROZEN_ORDER_KEEPER",
        ],
      },
    ],
    arbitrum: [
      {
        account: "0xe7bfff2ab721264887230037940490351700a068",
        roles: ["CONTROLLER", "MARKET_KEEPER"],
      },
      {
        account: "0x43ce1d475e06c65dd879f4ec644b8e0e10ff2b6d",
        roles: ["FEE_RECEIVER"],
      },
      {
        account: "0xE47b36382DC50b90bCF6176Ddb159C4b9333A7AB",
        roles: ["CONFIG_KEEPER"],
      },
      {
        account: "0xe97e935d4f5a533e61baaf0a3cc85db33ac71636",
        roles: ["CONFIG_KEEPER", "MARKET_KEEPER", "TIMELOCK_ADMIN"],
      },
      {
        account: "0x1c81F9dFD3DE4f9Bd2C11924D60f18a09Af13165",
        roles: ["CONFIG_KEEPER", "TIMELOCK_ADMIN", "TIMELOCK_MULTISIG"],
      },
      {
        account: "0xE47b36382DC50b90bCF6176Ddb159C4b9333A7AB",
        roles: ["ORDER_KEEPER", "ADL_KEEPER", "LIQUIDATION_KEEPER", "FROZEN_ORDER_KEEPER"],
      },
      {
        account: "0xC539cB358a58aC67185BaAD4d5E3f7fCfc903700",
        roles: ["ORDER_KEEPER", "ADL_KEEPER", "LIQUIDATION_KEEPER", "FROZEN_ORDER_KEEPER"],
      },
      {
        account: "0xf1e1B2F4796d984CCb8485d43db0c64B83C1FA6d",
        roles: ["ORDER_KEEPER", "ADL_KEEPER", "LIQUIDATION_KEEPER", "FROZEN_ORDER_KEEPER"],
      },
    ],
    avalanche: [
      {
        account: "0xe7bfff2ab721264887230037940490351700a068",
        roles: ["CONTROLLER", "MARKET_KEEPER"],
      },
      {
        account: "0x43ce1d475e06c65dd879f4ec644b8e0e10ff2b6d",
        roles: ["FEE_RECEIVER"],
      },
      {
        account: "0xE47b36382DC50b90bCF6176Ddb159C4b9333A7AB",
        roles: ["CONFIG_KEEPER"],
      },
      {
        account: "0xe97e935d4f5a533e61baaf0a3cc85db33ac71636",
        roles: ["CONFIG_KEEPER", "MARKET_KEEPER", "TIMELOCK_ADMIN"],
      },
      {
        account: "0x1c81F9dFD3DE4f9Bd2C11924D60f18a09Af13165",
        roles: ["CONFIG_KEEPER", "TIMELOCK_ADMIN", "TIMELOCK_MULTISIG"],
      },
      {
        account: "0xE47b36382DC50b90bCF6176Ddb159C4b9333A7AB",
        roles: ["ORDER_KEEPER", "ADL_KEEPER", "LIQUIDATION_KEEPER", "FROZEN_ORDER_KEEPER"],
      },
      {
        account: "0xC539cB358a58aC67185BaAD4d5E3f7fCfc903700",
        roles: ["ORDER_KEEPER", "ADL_KEEPER", "LIQUIDATION_KEEPER", "FROZEN_ORDER_KEEPER"],
      },
      {
        account: "0xf1e1B2F4796d984CCb8485d43db0c64B83C1FA6d",
        roles: ["ORDER_KEEPER", "ADL_KEEPER", "LIQUIDATION_KEEPER", "FROZEN_ORDER_KEEPER"],
      },
    ],
    arbitrumGoerli: [
      {
        account: "0xC84f3398eDf6336E1Ef55b50Ca3F9f9f96B8b504",
        roles: [
          "CONTROLLER",
          "ORDER_KEEPER",
          "ADL_KEEPER",
          "LIQUIDATION_KEEPER",
          "MARKET_KEEPER",
          "FROZEN_ORDER_KEEPER",
        ],
      },
      {
        account: "0xFb11f15f206bdA02c224EDC744b0E50E46137046",
        roles: [
          "CONTROLLER",
          "ORDER_KEEPER",
          "ADL_KEEPER",
          "LIQUIDATION_KEEPER",
          "MARKET_KEEPER",
          "FROZEN_ORDER_KEEPER",
        ],
      },
    ],
    avalancheFuji: [
      {
        account: "0xC84f3398eDf6336E1Ef55b50Ca3F9f9f96B8b504",
        roles: [
          "CONTROLLER",
          "ORDER_KEEPER",
          "ADL_KEEPER",
          "LIQUIDATION_KEEPER",
          "MARKET_KEEPER",
          "FROZEN_ORDER_KEEPER",
        ],
      },
      {
        account: "0xFb11f15f206bdA02c224EDC744b0E50E46137046",
        roles: [
          "CONTROLLER",
          "ORDER_KEEPER",
          "ADL_KEEPER",
          "LIQUIDATION_KEEPER",
          "MARKET_KEEPER",
          "FROZEN_ORDER_KEEPER",
        ],
      },
    ],
  };

  return config[hre.network.name];
}