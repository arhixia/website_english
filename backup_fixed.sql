--
-- PostgreSQL database dump
--

-- Dumped from database version 12.19
-- Dumped by pg_dump version 12.19

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.user_progress DROP CONSTRAINT user_progress_user_id_fkey;
ALTER TABLE ONLY public.user_progress DROP CONSTRAINT user_progress_test_id_fkey;
ALTER TABLE ONLY public.test_results DROP CONSTRAINT test_results_user_id_fkey;
ALTER TABLE ONLY public.test_results DROP CONSTRAINT test_results_test_id_fkey;
ALTER TABLE ONLY public.quizzes DROP CONSTRAINT quizzes_test_id_fkey;
ALTER TABLE ONLY public.quiz_results DROP CONSTRAINT quiz_results_user_id_fkey;
ALTER TABLE ONLY public.quiz_results DROP CONSTRAINT quiz_results_quiz_id_fkey;
DROP INDEX public.ix_users_username;
DROP INDEX public.ix_users_id;
DROP INDEX public.ix_user_progress_id;
DROP INDEX public.ix_tests_id;
DROP INDEX public.ix_test_results_id;
DROP INDEX public.ix_quizzes_id;
DROP INDEX public.ix_quiz_results_id;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY public.user_progress DROP CONSTRAINT user_progress_pkey;
ALTER TABLE ONLY public.tests DROP CONSTRAINT tests_pkey;
ALTER TABLE ONLY public.test_results DROP CONSTRAINT test_results_pkey;
ALTER TABLE ONLY public.quizzes DROP CONSTRAINT quizzes_pkey;
ALTER TABLE ONLY public.quiz_results DROP CONSTRAINT quiz_results_pkey;
ALTER TABLE ONLY public.alembic_version DROP CONSTRAINT alembic_version_pkc;
ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.user_progress ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.tests ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.test_results ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.quizzes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.quiz_results ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.users_id_seq;
DROP TABLE public.users;
DROP SEQUENCE public.user_progress_id_seq;
DROP TABLE public.user_progress;
DROP SEQUENCE public.tests_id_seq;
DROP TABLE public.tests;
DROP SEQUENCE public.test_results_id_seq;
DROP TABLE public.test_results;
DROP SEQUENCE public.quizzes_id_seq;
DROP TABLE public.quizzes;
DROP SEQUENCE public.quiz_results_id_seq;
DROP TABLE public.quiz_results;
DROP TABLE public.alembic_version;
DROP EXTENSION adminpack;
--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


--
-- Name: quiz_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quiz_results (
    id integer NOT NULL,
    quiz_id integer NOT NULL,
    user_answer character varying NOT NULL,
    is_correct boolean NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: quiz_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quiz_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quiz_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quiz_results_id_seq OWNED BY public.quiz_results.id;


--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quizzes (
    id integer NOT NULL,
    question text NOT NULL,
    options character varying[] NOT NULL,
    answer character varying NOT NULL,
    topic character varying NOT NULL,
    test_id integer NOT NULL,
    question_title character varying NOT NULL
);


--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quizzes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quizzes_id_seq OWNED BY public.quizzes.id;


--
-- Name: test_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.test_results (
    id integer NOT NULL,
    user_id integer NOT NULL,
    test_id integer NOT NULL,
    score integer NOT NULL,
    incorrect_topics character varying[]
);


--
-- Name: test_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.test_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: test_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.test_results_id_seq OWNED BY public.test_results.id;


--
-- Name: tests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tests (
    id integer NOT NULL,
    title character varying NOT NULL,
    description text
);


--
-- Name: tests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tests_id_seq OWNED BY public.tests.id;


--
-- Name: user_progress; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_progress (
    id integer NOT NULL,
    user_id integer NOT NULL,
    test_id integer NOT NULL,
    incorrect_questions integer[]
);


--
-- Name: user_progress_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_progress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_progress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_progress_id_seq OWNED BY public.user_progress.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying NOT NULL,
    hashed_password character varying NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: quiz_results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz_results ALTER COLUMN id SET DEFAULT nextval('public.quiz_results_id_seq'::regclass);


--
-- Name: quizzes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quizzes ALTER COLUMN id SET DEFAULT nextval('public.quizzes_id_seq'::regclass);


--
-- Name: test_results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_results ALTER COLUMN id SET DEFAULT nextval('public.test_results_id_seq'::regclass);


--
-- Name: tests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tests ALTER COLUMN id SET DEFAULT nextval('public.tests_id_seq'::regclass);


--
-- Name: user_progress id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_progress ALTER COLUMN id SET DEFAULT nextval('public.user_progress_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alembic_version (version_num) FROM stdin;
d2b09c978ffb
\.


--
-- Data for Name: quiz_results; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.quiz_results (id, quiz_id, user_answer, is_correct, user_id) FROM stdin;
661	4	c	t	2
662	5	a	f	2
663	6	c	f	2
664	7	c	f	2
665	8	c	f	2
666	9	a	f	2
667	10	b	f	2
668	11	c	f	2
669	12	c	t	2
670	13	b	f	2
\.


--
-- Data for Name: quizzes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.quizzes (id, question, options, answer, topic, test_id, question_title) FROM stdin;
4	For me, an important question is С‚РђРЁDo you ______ or do you tend to be around a lot?С‚РђР©	{"a) a people person","b) a computer geek","c) keep yourself to yourself","d) witty"}	c	Complete the Conversation with Words from the Box	1	Complete the sentence
5	Can you tell me why you are studying English?	{"a) Why are you studying English?","b) Can you tell me why you are studying English?","c) Can I ask why you are studying English?","d) Can you tell me if you are studying English?"}	b	Direct and Indirect Questions	1	Make Sentences with the Opening Phrases
6	I ______ my first challenge.	{"a) have just finished","b) just finished","c) have finished just","d) have finishing"}	a	Present Perfect	1	Complete These Sentences Using the Words in Brackets
7	I ______ (never) anything online С‚РђРЈ IС‚РђР©m paranoid about giving my credit card details, but I know itС‚РђР©s cheaper, so that would be my choice.	{"a) never bought","b) never buy","c) havenС‚РђР©t bought","d) havenС‚РђР©t buy"}	a	Present Perfect	1	Complete the Sentences with the Present Perfect or Past Simple of the Verbs in the Box. Include the Adverbs in Brackets
8	People often comment on my ______.	{"a) spontaneous","b) spontaneity","c) spontaneousness","d) spontaneously"}	b	Additional tasks	1	Complete the Sentences in the Personality Quiz with the Correct Noun or Adjective Form
9	She has a quick mind and is good with words. SheС‚РђР©s ______.	{"a) a people person","b) spontaneous","c) down-to-earth","d) witty"}	d	Expressing Likes and Dislikes	1	Complete the Sentences with an Adjective Phrase
10	A: Hey, IС‚РђР©ve got the job!\\nB: Congratulations! You must be ______.	{"a) over the moon","b) relieved","c) shaking like a leaf","d) frustrated"}	a	Complete the Conversation with Words from the Box	1	Complete the Conversations with Words and Phrases from the Box. Not All Items Are Needed.
11	Since I ______ this course, I ______ my speaking.	{"a) started, improved","b) have started, have improved","c) started, have improved","d) start, improve"}	b	Present Perfect	1	Complete the Sentences with the Present Perfect or Past Simple of the Verbs in the Box
12	This is a purely domestic issue	{"a) so, taxes will double next year.","b) not people living in cities.","c) and has nothing to do with any other country.","d) not just one or two countries."}	c	Additional tasks	1	Match the Beginnings 1С‚РђРЈ8 with the Endings a)С‚РђРЈh)
13	The environmental group Ocean Project has ______ that sea levels will rise one metre in ...	{"a) projected","b) appealed","c) recorded","d) permitted"}	a	Additional tasks	1	Complete the Sentences with the Correct Form of One of the Words in the Box
14	A: I / favour / banning smoking / all public places.	{"a) IС‚РђР©m in favour of banning smoking in all public places.","b) I think banning smoking in all public places should be considered.","c) IС‚РђР©m not sure about banning smoking in all public places.","d) I oppose banning smoking in all public places."}	a	Opinions	2	Practise the Conversations Using the Prompts
15	I find it deeply disturbing that children are forced to work in factories.	{"a) having good reasons","b) against the law","c) morally wrong","d) shocking and unacceptable","e) very worrying","f) not thinking about the results of your actions"}	e	Opinions	2	Read Sentences 1С‚РђРЈ6 and Match the Adjectives in Bold with Items a)С‚РђРЈf) Which Are Similar in Meaning
16	Why is gang violence more of an ur___ problem than a ru___ problem?	{"a) urban, radical","b) urgent, random","c) urban, rural","d) urgent, rural"}	c	Additional tasks	2	Add Letters to Complete the Adjectives
17	Have / you / ever / bitten / by / an / animal?	{"a) Have you ever been given advice by someone you trust?","b) Have you ever been invited to a party by a friend?","c) Have you ever been spoken to by a stranger?","d) Have you ever been bitten by an animal?"}	d	Direct and Indirect Questions	2	Put the Words in the Correct Order to Make Passive Questions
19	1. A young person who starts up her own business and succeeds despite dr____ changes of fortune. This is an int___ story about a re___ woman. It makes you think anything is possible if you want it enough.\\n2. A hi____ description of a trip across India, full of laugh-out-loud situations. Jerry manages to lose his passport five times and meets up with a series of inc____ fellow-travellers whose stories you just cant believe!\\n3. A depressing picture of the difficulties facing a poor family in 1930s America. The story of their search for work is poi____ and very mo____, but their strength is truly ins____.	{"a) dramatic, inspiring, remarkable","b) hilarious, incredible","c) poignant, moving, inspiring","d) dramatic, incredible, inspiring"}	a	Additional tasks	2	Complete the Adjectives in the Stories
20	1. ______ I really like about it is ...\\n2. I donС‚РђР©t like X ______ much.\\n3. The ______ I love about it is ...\\n4. I just canС‚РђР©t ______ into ...\\n5. IС‚РђР©m a big ______ of ...\\n6. I canС‚РђР©t ______ ...	{"a) That, what, get, thing, fan, stand","b) What, that, thing, get, fan, stand","c) What, thing, get, fan, stand, that","d) That, fan, stand, thing, get, what"}	b	Opinions	2	Complete the Phrases with Words from the Box
21	DonС‚РђР©t wait till itС‚РђР©s too late!\\nThese days more than ever, itС‚РђР©s important to know how to С‚РђРЁr_ch_ro_ . But some people donС‚РђР©t know how to relax and how important it is to do so before itС‚РђР©s too late.\\nFirst of all, notice the danger signals. If you get С‚РђРЁw__nd_p easily by the little annoying things people do, itС‚РђР©s time for a break. ItС‚РђР©s time to С‚РђРЁf_c_s _n yourself! Go and sit by a lake or on top of a hill. DonС‚РђР©t think about anything, just С‚РђРЁch_ll _t. DonС‚РђР©t listen to music or anything С‚РђРЈ music might be another way to С‚РђРЁsw_tch _ff, but itС‚РђР©s an artificial solution. So listen to the wind and the water. YouС‚РђР©ll feel your energy change, youС‚РђР©ll feel yourself _nw_nd.	{"a) recover, wound up, focus in, chill out, switch off, unwind","b) recharge, wound up, focus on, chill out, switch off, unwind","c) recharge, wind up, focus on, chill out, switch off, unwind","d) relax, wound up, focus on, chill out, switch off, unwind"}	b	Additional tasks	2	Add the Vowels to Complete the Verbs
22	1. I have the practical knowledge needed. I have the necessary ______.\\n2. I know a lot about what people are like. I ______.\\n3. I can make people laugh. I have ______.\\n4. I donС‚РђР©t get nervous under pressure. IС‚РђР©m ______.\\n5. IС‚РђР©m in good health and condition. IС‚РђР©m ______.\\n6. I can come up with new things easily. IС‚РђР©m ______.\\n7. I can think quickly. I have ______.\\n8. IС‚РђР©m talented or skilled in (various fields). IС‚РђР©m ______.	{"a) inventive, good with words, a sharp mind, cool-headed, in great shape, understand human nature, know-how, a good sense of humor","b) a sharp mind, good with hands, cool-headed, inventive, in great shape, good with words, understand human nature, a good sense of humor","c) know-how, understand human nature, a good sense of humor, cool-headed, in great shape, inventive, a sharp mind, good with words","d) a sharp mind, cool-headed, in great shape, understand human nature, know-how, a good sense of humor, inventive, good with words"}	c	Opinions	2	Complete Sentences 1С‚РђРЈ8 with the Phrases in the Box
23	1. a ______ place to relax (в•Ёв”‚в•¤Рђв•Ёв•Ўв•¤Р‘в•¤Р‘в•Ёв•Ўв•¤Р’)\\n2. a ______ book (aislesc)\\n3. a ______ view of a city (rheabnikatgt)\\n4. a ______ restaurant (ubpesr)\\n5. someone with a/an ______ talent (likeeoncpat)\\n6. a ______ improvement to public transport (figistnican)\\n7. a ______ village (flughdielt)\\n8. ______ scenery (tnninsgu)	{"a) serene, classic, breathtaking, superb, exceptional, significant, delightful, stunning","b) serene, classic, breathtaking, superb, significant, delightful, exceptional, stunning","c) superb, classic, breathtaking, serene, exceptional, significant, delightful, stunning","d) stunning, exceptional, classic, breathtaking, serene, delightful, significant, superb"}	a	Additional tasks	2	Rearrange the Letters to Complete the Phrases
24	The key thing is ______.	{"a) that the other team interrogates the storyteller.","b) to say something thatС‚РђР©s so unbelievable that itС‚РђР©s hard to imagine itС‚РђР©s true.","c) jump over the arm when it gets to you.","d) twelve of the contestants stand on podiums over water."}	b	Explaining Procedures	3	Match the Sentence Halves to Make Phrases for Explaining Procedures
25	My phoneС‚РђР©s dead. I need to ______ it.	{"a) wind up","b) recharge","c) chill","d) switch off"}	b	Describing Procedures	3	Complete the Sentences with the Correct Form of One of the Verbs in the Box
26	Which question is correctly formed?	{"a) Where you been?","b) Where have you been?","c) Where did been you?","d) Where are been you?"}	b	Direct and Indirect Questions	3	Write AС‚РђР©s Questions in Full
27	Which question is correctly structured?	{"a) Do they know if you accept credit cards here?","b) Do they if know accept credit cards you here?","c) They do know accept credit cards if here you?","d) Know do they if accept you credit cards here?"}	a	Direct and Indirect Questions	3	Put the Words in the Correct Order to Make Indirect Questions
28	I cant meet you tonight. No? How ______?	{"a) time","b) much","c) come","d) long"}	c	Direct and Indirect Questions	3	Complete the Two-Word Questions
29	I have never played squash ______.	{"a) after","b) before","c) since","d) this morning"}	b	Present Perfect	3	Choose the Correct Time Phrase
30	Which verb form best completes the sentence? Because I ______ a new pair of jeans.	{"a) have just bought","b) just bought","c) have been buying","d) buying"}	a	Present Perfect Simple and Continuous	3	Complete the Answers with the Present Perfect Simple or Continuous Form of the Verbs in Brackets
31	Which sentence correctly uses future forms?	{"a) I will staying at home this evening, but I havenС‚РђР©t decided yet. Maybe I will watching a DVD or something.","b) I might staying at home this evening, but I havenС‚РђР©t decided yet. Maybe I watching a DVD or something.","c) I stay at home this evening, but I havenС‚РђР©t decided yet. Maybe I watch a DVD or something.","d) I might stay at home this evening, but I havenС‚РђР©t decided yet. Maybe I will watch a DVD or something."}	d	Future Forms	3	Complete the Sentences with an Appropriate Future Form
32	Which sentence uses articles correctly?	{"a) When people think of a inventors, they might think of Thomas Edison and a light bulb or Gutenberg and printing press.","b) When people think of the inventors, they might think of the Thomas Edison and light bulb or Gutenberg and printing press.","c) When people think of inventors, they might think of Thomas Edison and the light bulb or Gutenberg and the printing press.","d) When people think of inventors, they might think of a Thomas Edison and an light bulb or the Gutenberg and a printing press."}	c	Articles	3	Complete the Text with a/an, the or No Article (-)
33	Which sentence correctly uses conditionals?	{"a) If you give me your phone number, I asking Pete to call you back.","b) If you give me your phone number, I will ask Pete to call you back.","c) If you give me your phone number, I asked Pete to call you back.","d) If you give me your phone number, I would ask Pete to call you back."}	b	Real and Hypothetical Conditionals	3	Complete the Sentences with the Appropriate Form of the Verbs in Brackets
34	By the time she ___ (finish) her report, her colleagues ___ (already/leave) the office.	{"a) finished, had already left","b) had finished, already left","c) has finished, had already left","d) was finishing, already left"}	a	Present Perfect	4	Present Perfect vs. Past Perfect
35	Which sentence is the correct indirect form of: "Where did you buy this book?"	{"a) Can you tell me where did you buy this book?","b) Could you tell me where you bought this book?","c) I wonder where you buy this book?","d) Do you know where you did buy this book?"}	b	Direct and Indirect Questions	4	Direct and Indirect Questions
36	She ___ (study) for the exam all week, so sheС‚РђР©s exhausted.	{"a) studied","b) has studied","c) has been studying","d) is studying"}	c	Present Perfect	4	Present Perfect Continuous
37	His ___ in solving complex problems impressed the entire team.	{"a) ingenuity","b) ingenious","c) ingeniously","d) ingenuity"}	a	Additional tasks	4	Adjective/Noun Forms
38	I canС‚РђР©t ___ people who are always lateС‚РђР¤itС‚РђР©s so disrespectful.	{"a) stand","b) tolerate","c) appreciate","d) admire"}	a	Expressing Likes and Dislikes	4	Expressing Likes and Dislikes
39	By 2030, scientists ___ (develop) a vaccine for most rare diseases.	{"a) will develop","b) will have developed","c) are developing","d) developed"}	b	Future Forms	4	Future Perfect
40	___ Mount Everest is ___ highest peak in ___ world.	{"a) -, the, the","b) The, the, the","c) -, a, the","d) The, a, -"}	a	Articles	4	Articles (Advanced Usage)
41	If he ___ (not/oversleep), he ___ (not/miss) his flight.	{"a) hadnС‚РђР©t overslept, wouldnС‚РђР©t have missed","b) didnС‚РђР©t oversleep, wouldnС‚РђР©t miss","c) hasnС‚РђР©t overslept, wouldnС‚РђР©t have missed","d) wouldnС‚РђР©t oversleep, hadnС‚РђР©t missed"}	a	Real and Hypothetical Conditionals	4	Hypothetical Conditionals
42	The proposal ___ (discuss) at the meeting before a decision is made.	{"a) will discuss","b) will be discussed","c) is discussing","d) has discussed"}	b	Describing Procedures	4	Passive Voice (Complex Structures)
43	The politicianС‚РђР©s speech was ___С‚РђР¤full of half-truths and exaggerations.	{"a) persuasive","b) eloquent","c) misleading","d) insightful"}	c	Opinions	4	Synonyms (Precise Word Choice)
18	Stories:\n1. Wrong era, wrong class, wrong gender.\n2. Really should have been a lawyer.\n3. Born London, lived elsewhere, died inside.\n4. Any chance I could start again?\n5. Worry about tomorrow, rarely enjoy today!\n6. Married, TV, computer, never any flowers.\nSentences to Match:\na) I wish I could do it all again.\nb) I wish I werenС‚РђР©t so anxious.\nc) I wish IС‚РђР©d stayed where I was happy.\nd) I wish heС‚РђР©d pay more attention to me.\ne) If only I hadnС‚РђР©t become a doctor.\nf) If only IС‚РђР©d been born twenty years later.	{"a) 1 - f, 2 - e, 3 - c, 4 - a, 5 - b, 6 - d","b) 1 - e, 2 - f, 3 - d, 4 - b, 5 - a, 6 - c","c) 1 - a, 2 - b, 3 - f, 4 - c, 5 - e, 6 - d","d) 1 - c, 2 - a, 3 - e, 4 - d, 5 - f, 6 - b"}	a	I Wish, If Only	2	Match Sentences a)С‚РђРЈf) with Stories 1С‚РђРЈ6 Above
\.


--
-- Data for Name: test_results; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.test_results (id, user_id, test_id, score, incorrect_topics) FROM stdin;
67	2	1	2	{"Additional tasks","Direct and Indirect Questions","Present Perfect","Complete the Conversation with Words from the Box","Expressing Likes and Dislikes"}
\.


--
-- Data for Name: tests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tests (id, title, description) FROM stdin;
1	First Test	This is the first test.
2	Second Test	This is the second test.
3	Third Test	This is the third test.
4	Fourth Test	This is the fourth test.
\.


--
-- Data for Name: user_progress; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_progress (id, user_id, test_id, incorrect_questions) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, hashed_password) FROM stdin;
1	arhixia	$2b$12$rLT8v0Ohl3gxmk1Y.cYem.mLnxlBrziZ7KPo8JnkVHildHqelmdqi
2	vova	$2b$12$5g6ETj5JvoiI10Iw1Ie4h.h1.pRRMf63hfqlK9Awfu8KEyTKEHsiO
3	nigger	$2b$12$AjihV45HpXbZsfxYOWp8wukdTEvP.rycXczxbWnKJp2lxMft4I4Qu
4	vova228	$2b$12$LZarKvKNvXVtsTdiqpOshe7hZBVZiYSTAuk5fiS147zGzCwIoLRGG
5	vova1337	$2b$12$7obMip3/Z0SSaHK9j7NBEevtrwFHH7GbuBwohKTxWyGRyv0SKxWMm
6	vova1337228	$2b$12$LsaPXUppjUXt6lc9S1Ih4.ZL84hbu/7.o1d7n03K7JtOjjHzMbyYC
7	vova13372282	$2b$12$KQHqmPdwrFnuV5ZFNZ455.bmKHLKJfDobvne0mwWqBjl7qtqFE.Pe
\.


--
-- Name: quiz_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.quiz_results_id_seq', 670, true);


--
-- Name: quizzes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.quizzes_id_seq', 43, true);


--
-- Name: test_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.test_results_id_seq', 67, true);


--
-- Name: tests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tests_id_seq', 1, false);


--
-- Name: user_progress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_progress_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 7, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: quiz_results quiz_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz_results
    ADD CONSTRAINT quiz_results_pkey PRIMARY KEY (id);


--
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: test_results test_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_results
    ADD CONSTRAINT test_results_pkey PRIMARY KEY (id);


--
-- Name: tests tests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_pkey PRIMARY KEY (id);


--
-- Name: user_progress user_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_progress
    ADD CONSTRAINT user_progress_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: ix_quiz_results_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_quiz_results_id ON public.quiz_results USING btree (id);


--
-- Name: ix_quizzes_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_quizzes_id ON public.quizzes USING btree (id);


--
-- Name: ix_test_results_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_test_results_id ON public.test_results USING btree (id);


--
-- Name: ix_tests_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_tests_id ON public.tests USING btree (id);


--
-- Name: ix_user_progress_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_user_progress_id ON public.user_progress USING btree (id);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: ix_users_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_users_username ON public.users USING btree (username);


--
-- Name: quiz_results quiz_results_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz_results
    ADD CONSTRAINT quiz_results_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id);


--
-- Name: quiz_results quiz_results_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz_results
    ADD CONSTRAINT quiz_results_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: quizzes quizzes_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_test_id_fkey FOREIGN KEY (test_id) REFERENCES public.tests(id);


--
-- Name: test_results test_results_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_results
    ADD CONSTRAINT test_results_test_id_fkey FOREIGN KEY (test_id) REFERENCES public.tests(id);


--
-- Name: test_results test_results_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_results
    ADD CONSTRAINT test_results_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_progress user_progress_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_progress
    ADD CONSTRAINT user_progress_test_id_fkey FOREIGN KEY (test_id) REFERENCES public.tests(id);


--
-- Name: user_progress user_progress_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_progress
    ADD CONSTRAINT user_progress_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--



