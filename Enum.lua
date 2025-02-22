AutoBiographerEnum = {
  AuctionHouseMessageType = {
    Bought = 0,
    Canceled = 1,
    Expired = 2,
    Outbid = 3,
    Sold = 4,
  },
  DamageOrHealingCategory = {
    DamageDealt = 0,
    DamageTaken = 1,
    HealingDealtToOthers = 2,
    HealingDealtToSelf = 3,
    HealingTaken = 4,
    PetDamageDealt = 5,
    PetDamageTaken = 6,
  },
  DeathTrackingType = {
    DeathToCreature = 0,
    DeathToEnvironment = 1,
    DeathToPet = 2,
    DeathToPlayer = 3,
    DeathToGameObject = 4,
  },
  EventType = {
    Battleground = 0,
    Death = 1,
    Level = 2,
    Gathering = 3,
    Guild = 4,
    Instance = 5,
    Item = 6,
    Kill = 7,
    Map = 8,
    Miscellaneous = 9,
    Money = 10,
    Pvp = 11,
    Quest = 12,
    Skill = 13,
    Spell = 14,
    Talent = 15,
    Time = 16,
    Xp = 17,
    Reputation = 18,
  },
  EventSubType = {
    BossKill = 0,
    FirstAcquiredItem = 1,
    FirstKill = 2,
    GuildJoined = 3,
    GuildLeft = 4,
    GuildRankChanged = 5,
    LevelUp = 6,
    PlayerDeath = 7,
    QuestTurnIn = 8,
    SkillMilestone = 9,
    SpellLearned = 10,
    SubZoneFirstVisit = 11,
    ZoneFirstVisit = 12,
    ReputationLevelChanged = 13,
    BattlegroundJoined = 14,
    BattlegroundLost = 15,
    BattlegroundWon = 16,
  },
  ExperienceTrackingType = {
    Discovery = 0,
    Kill = 1,
    GroupBonus = 2,
    RaidPenalty = 3,
    RestedBonus = 4,
    Quest = 5,
  },
  ItemAcquisitionMethod = {
    Create = 0,
    Loot = 1,
    Other = 2,
    Quest = 3,
    Trade = 4,
    AuctionHouse = 5,
    Mail = 6,
    MailCod = 7,
    Merchant = 8,
  },
  KillTrackingType = {
    TaggedAssist = 0,
    TaggedGroupAssistOrKillingBlow = 1,
    TaggedKillingBlow = 2,
    UntaggedAssist = 3,
    UntaggedGroupAssistOrKillingBlow = 4,
    UntaggedKillingBlow = 5,
  },
  LogLevel = {
    Verbose = 0,
    Debug = 1,
    Information = 2,
    Warning = 3,
    Error = 4,
    Fatal = 5
  },
  MiscellaneousTrackingType = {
    PlayerDeaths = 0, -- Deprecated
    Jumps = 1,
  },
  MoneyAcquisitionMethod = {
    AuctionHouseSale = 0,
    Loot = 1,
    Other = 2,
    Quest = 3,
    Trade = 4,
    AuctionHouseDepositReturn = 5,
    AuctionHouseOutbid = 6,
    Mail = 7,
    MailCod = 8,
    Merchant = 9,
  },
  OtherPlayerTrackingType = {
    DuelsLostToPlayer = 0,
    DuelsWonAgainstPlayer = 1,
    TimeSpentGroupedWithPlayer = 2,
  },
  SpellTrackingType = {
    StartedCasting = 0,
    SuccessfullyCast = 1,
  },
  StatisticsDisplayMode = {
    Items = 0,
    Kills = 1,
    OtherPlayers = 2,
    Spells = 3,
    Time = 4,
  },
  TimeTrackingType = {
    Afk = 0,
    Casting = 1,
    DeadOrGhost = 2,
    InCombat = 3,
    LoggedIn = 4,
    OnTaxi = 5,
    InParty = 6,
  },
  UnitType = {
    Creature = 0,
    Pet = 1,
    Player = 2,
    GameObject = 3,
  }
}