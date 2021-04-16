// NOTE: This is a simple example.
// Please refer to https://github.com/mbrt/gmailctl#configuration for docs about
// the config format. Don't forget to change the configuration before to apply it
// to your own inbox!

// Import the standard library
local lib = import 'gmailctl.libsonnet';

// Some useful variables on top
// TODO: Put your email here
local me = 'paul.huckabee@gmail.com';
local toMe = { to: me };

local and(c) = { and: c };
local or(c) = { or: c };
local not(c) = { not: c };
local neither(c) = not(or(c));

local from(a) = { from: a };
local to(a) = { to: a };
local cc(a) = { cc: a };
local sub(s) = { subject: s };
local body(s) = { has: s };
local list(s) = { list: s };

local filters = {
  important:
    [
      from('avisandersphd@gmail.com'),
      from('theDreebs@gmail.com'),
      body('anna skiandos'),
      body('vaccine'),
      body('Vaccine'),
    ],
  lists:
    [
      list('0afd67a5c5ed54633aface96f.421029.list-id.mcsv.net'),
    ],
  reddit:
    [
      from('noreply@redditmail.com'),
    ],
  spam:
    [
      from('components@newsletters.electronicproducts.com'),
      from('customerservice@vapordna.com'),
      from('info@mailer.netflix.com'),
      from('info@*'),
      from('noreply@energyreports.coned.com'),
      from('*@*.microsoft.com'),
      from('noreply@smartmeters@coned.com'),
      from('rockport@e.rockport.com'),
      from('sendhappy@urbanstems.com'),
      from('store-news@amazon.com'),
      from('store-news@woot.com'),
      from('wholefoodsmarket@mail.wholefoodsmarket.com'),
      list('1319011.xt.local'),
      list('7bc3d93c3ef56630a5bfb571d0118d1035153557.google.com'),
      list('7282972.xt.local'),
      list('f452ec3bdbd6b3981f19e668a.342965.list-id.mcsv.net'),
      list('8a69dd64a22574a778a452ae6c030518e0a78ab1.google.com'),
    ],
};

// The actual configuration
{
  // Mandatory header
  version: 'v1alpha3',
  author: {
    name: 'Paul Huckabee',
    email: me,
  },

  // Labels
  labels: [
    { name: 'Me' },
    { name: 'WetzelFam' },
    { name: 'Lists' },
    { name: 'Orders' },
    { name: 'Reddit' },
    { name: 'Reddit/SD' },
  ],

  rules: [
    {
      filter: toMe,
      actions: {
        labels: ['Me'],
        markImportant: true,
      },
    },

    {
      filter: { list: 'wetzel-family@googlegroups.com' },
      actions: {
        labels: ['WetzelFam'],
        markImportant: true,
      },
    },

    {
      filter: {
        or: [
          { from: 'order*@*' },
          { from: 'orders@*' },
        ],
      },
      actions: {
        labels: ['Orders'],
        archive: true,
      },
    },

    {
      filter: { or: filters.important },
      actions: {
        archive: false,
        markRead: false,
        markImportant: true,
        star: true,
      },
    },

    {
      filter: and([from('noreply@redditmail.com'), sub('stopdrinking')]),
      actions: {
        archive: true,
        labels: ['Reddit/SD'],
        markRead: false,
        markImportant: false,
        star: false,
      },
    },

    {
      filter: { or: filters.lists },
      actions: {
        archive: true,
        markRead: false,
        markImportant: false,
        star: false,
      },
    },

    {
      filter: { or: filters.spam },
      actions: {
        archive: true,
        markRead: true,
        markImportant: false,
      },
    },
  ],
}
