--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: ConversationVisibility; Type: TYPE; Schema: public; Owner: shimmer_owner
--

CREATE TYPE public."ConversationVisibility" AS ENUM (
    'PRIVATE',
    'PUBLIC_LINK',
    'PUBLIC_GROUP',
    'PUBLIC_DOCUMENT',
    'PUBLIC_DATAROOM'
);


ALTER TYPE public."ConversationVisibility" OWNER TO shimmer_owner;

--
-- Name: CustomFieldType; Type: TYPE; Schema: public; Owner: shimmer_owner
--

CREATE TYPE public."CustomFieldType" AS ENUM (
    'SHORT_TEXT',
    'LONG_TEXT',
    'NUMBER',
    'PHONE_NUMBER',
    'URL',
    'CHECKBOX',
    'SELECT',
    'MULTI_SELECT'
);


ALTER TYPE public."CustomFieldType" OWNER TO shimmer_owner;

--
-- Name: DocumentStorageType; Type: TYPE; Schema: public; Owner: shimmer_owner
--

CREATE TYPE public."DocumentStorageType" AS ENUM (
    'S3_PATH',
    'VERCEL_BLOB'
);


ALTER TYPE public."DocumentStorageType" OWNER TO shimmer_owner;

--
-- Name: EmailType; Type: TYPE; Schema: public; Owner: shimmer_owner
--

CREATE TYPE public."EmailType" AS ENUM (
    'FIRST_DAY_DOMAIN_REMINDER_EMAIL',
    'FIRST_DOMAIN_INVALID_EMAIL',
    'SECOND_DOMAIN_INVALID_EMAIL',
    'FIRST_TRIAL_END_REMINDER_EMAIL',
    'FINAL_TRIAL_END_REMINDER_EMAIL'
);


ALTER TYPE public."EmailType" OWNER TO shimmer_owner;

--
-- Name: ItemType; Type: TYPE; Schema: public; Owner: shimmer_owner
--

CREATE TYPE public."ItemType" AS ENUM (
    'DATAROOM_DOCUMENT',
    'DATAROOM_FOLDER'
);


ALTER TYPE public."ItemType" OWNER TO shimmer_owner;

--
-- Name: LinkAudienceType; Type: TYPE; Schema: public; Owner: shimmer_owner
--

CREATE TYPE public."LinkAudienceType" AS ENUM (
    'GENERAL',
    'GROUP',
    'TEAM'
);


ALTER TYPE public."LinkAudienceType" OWNER TO shimmer_owner;

--
-- Name: LinkType; Type: TYPE; Schema: public; Owner: shimmer_owner
--

CREATE TYPE public."LinkType" AS ENUM (
    'DOCUMENT_LINK',
    'DATAROOM_LINK'
);


ALTER TYPE public."LinkType" OWNER TO shimmer_owner;

--
-- Name: ParticipantRole; Type: TYPE; Schema: public; Owner: shimmer_owner
--

CREATE TYPE public."ParticipantRole" AS ENUM (
    'OWNER',
    'PARTICIPANT'
);


ALTER TYPE public."ParticipantRole" OWNER TO shimmer_owner;

--
-- Name: Role; Type: TYPE; Schema: public; Owner: shimmer_owner
--

CREATE TYPE public."Role" AS ENUM (
    'ADMIN',
    'MEMBER',
    'MANAGER'
);


ALTER TYPE public."Role" OWNER TO shimmer_owner;

--
-- Name: TagType; Type: TYPE; Schema: public; Owner: shimmer_owner
--

CREATE TYPE public."TagType" AS ENUM (
    'LINK_TAG',
    'DOCUMENT_TAG',
    'DATAROOM_TAG'
);


ALTER TYPE public."TagType" OWNER TO shimmer_owner;

--
-- Name: ViewType; Type: TYPE; Schema: public; Owner: shimmer_owner
--

CREATE TYPE public."ViewType" AS ENUM (
    'DOCUMENT_VIEW',
    'DATAROOM_VIEW'
);


ALTER TYPE public."ViewType" OWNER TO shimmer_owner;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Account; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Account" (
    id text NOT NULL,
    "userId" text NOT NULL,
    type text NOT NULL,
    provider text NOT NULL,
    "providerAccountId" text NOT NULL,
    refresh_token text,
    access_token text,
    expires_at integer,
    token_type text,
    scope text,
    id_token text,
    session_state text
);


ALTER TABLE public."Account" OWNER TO shimmer_owner;

--
-- Name: Agreement; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Agreement" (
    id text NOT NULL,
    name text NOT NULL,
    content text NOT NULL,
    "teamId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "requireName" boolean DEFAULT true NOT NULL,
    "deletedAt" timestamp(3) without time zone,
    "deletedBy" text
);


ALTER TABLE public."Agreement" OWNER TO shimmer_owner;

--
-- Name: AgreementResponse; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."AgreementResponse" (
    id text NOT NULL,
    "agreementId" text NOT NULL,
    "viewId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."AgreementResponse" OWNER TO shimmer_owner;

--
-- Name: Brand; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Brand" (
    id text NOT NULL,
    logo text,
    "brandColor" text,
    "accentColor" text,
    "teamId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Brand" OWNER TO shimmer_owner;

--
-- Name: Chat; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Chat" (
    id text NOT NULL,
    "threadId" text NOT NULL,
    "userId" text NOT NULL,
    "documentId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "lastMessageAt" timestamp(3) without time zone
);


ALTER TABLE public."Chat" OWNER TO shimmer_owner;

--
-- Name: Conversation; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Conversation" (
    id text NOT NULL,
    title text,
    "isEnabled" boolean DEFAULT true NOT NULL,
    "visibilityMode" public."ConversationVisibility" DEFAULT 'PRIVATE'::public."ConversationVisibility" NOT NULL,
    "dataroomId" text NOT NULL,
    "dataroomDocumentId" text,
    "documentVersionNumber" integer,
    "documentPageNumber" integer,
    "linkId" text,
    "viewerGroupId" text,
    "initialViewId" text,
    "lastMessageAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "teamId" text NOT NULL
);


ALTER TABLE public."Conversation" OWNER TO shimmer_owner;

--
-- Name: ConversationParticipant; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."ConversationParticipant" (
    id text NOT NULL,
    "conversationId" text NOT NULL,
    role public."ParticipantRole" DEFAULT 'PARTICIPANT'::public."ParticipantRole" NOT NULL,
    "viewerId" text,
    "userId" text,
    "receiveNotifications" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."ConversationParticipant" OWNER TO shimmer_owner;

--
-- Name: ConversationView; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."ConversationView" (
    id text NOT NULL,
    "conversationId" text NOT NULL,
    "viewId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."ConversationView" OWNER TO shimmer_owner;

--
-- Name: CustomField; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."CustomField" (
    id text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    type public."CustomFieldType" NOT NULL,
    identifier text NOT NULL,
    label text NOT NULL,
    placeholder text,
    required boolean DEFAULT false NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    "linkId" text NOT NULL,
    "orderIndex" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."CustomField" OWNER TO shimmer_owner;

--
-- Name: CustomFieldResponse; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."CustomFieldResponse" (
    id text NOT NULL,
    data jsonb NOT NULL,
    "viewId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."CustomFieldResponse" OWNER TO shimmer_owner;

--
-- Name: Dataroom; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Dataroom" (
    id text NOT NULL,
    "pId" text NOT NULL,
    name text NOT NULL,
    "teamId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "conversationsEnabled" boolean DEFAULT false NOT NULL,
    description text
);


ALTER TABLE public."Dataroom" OWNER TO shimmer_owner;

--
-- Name: DataroomBrand; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."DataroomBrand" (
    id text NOT NULL,
    logo text,
    banner text,
    "brandColor" text,
    "accentColor" text,
    "dataroomId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."DataroomBrand" OWNER TO shimmer_owner;

--
-- Name: DataroomDocument; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."DataroomDocument" (
    id text NOT NULL,
    "dataroomId" text NOT NULL,
    "documentId" text NOT NULL,
    "folderId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "orderIndex" integer
);


ALTER TABLE public."DataroomDocument" OWNER TO shimmer_owner;

--
-- Name: DataroomFolder; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."DataroomFolder" (
    id text NOT NULL,
    name text NOT NULL,
    path text NOT NULL,
    "parentId" text,
    "dataroomId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "orderIndex" integer
);


ALTER TABLE public."DataroomFolder" OWNER TO shimmer_owner;

--
-- Name: Document; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Document" (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    file text NOT NULL,
    type text,
    "numPages" integer,
    "ownerId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "teamId" text NOT NULL,
    "assistantEnabled" boolean DEFAULT false NOT NULL,
    "storageType" public."DocumentStorageType" DEFAULT 'VERCEL_BLOB'::public."DocumentStorageType" NOT NULL,
    "folderId" text,
    "advancedExcelEnabled" boolean DEFAULT false NOT NULL,
    "contentType" text,
    "originalFile" text,
    "downloadOnly" boolean DEFAULT false NOT NULL,
    "isExternalUpload" boolean DEFAULT false NOT NULL
);


ALTER TABLE public."Document" OWNER TO shimmer_owner;

--
-- Name: DocumentPage; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."DocumentPage" (
    id text NOT NULL,
    "versionId" text NOT NULL,
    "pageNumber" integer NOT NULL,
    file text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "embeddedLinks" text[],
    "storageType" public."DocumentStorageType" DEFAULT 'VERCEL_BLOB'::public."DocumentStorageType" NOT NULL,
    metadata jsonb,
    "pageLinks" jsonb
);


ALTER TABLE public."DocumentPage" OWNER TO shimmer_owner;

--
-- Name: DocumentUpload; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."DocumentUpload" (
    id text NOT NULL,
    "documentId" text NOT NULL,
    "teamId" text NOT NULL,
    "viewerId" text,
    "viewId" text,
    "linkId" text NOT NULL,
    "dataroomId" text,
    "dataroomDocumentId" text,
    "originalFilename" text,
    "fileSize" integer,
    "mimeType" text,
    "uploadedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "numPages" integer
);


ALTER TABLE public."DocumentUpload" OWNER TO shimmer_owner;

--
-- Name: DocumentVersion; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."DocumentVersion" (
    id text NOT NULL,
    "versionNumber" integer NOT NULL,
    "documentId" text NOT NULL,
    file text NOT NULL,
    type text,
    "numPages" integer,
    "isPrimary" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "hasPages" boolean DEFAULT false NOT NULL,
    "fileId" text,
    "storageType" public."DocumentStorageType" DEFAULT 'VERCEL_BLOB'::public."DocumentStorageType" NOT NULL,
    "isVertical" boolean DEFAULT false NOT NULL,
    "contentType" text,
    "originalFile" text,
    "fileSize" integer,
    length integer
);


ALTER TABLE public."DocumentVersion" OWNER TO shimmer_owner;

--
-- Name: Domain; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Domain" (
    id text NOT NULL,
    slug text NOT NULL,
    "userId" text,
    verified boolean DEFAULT false NOT NULL,
    "lastChecked" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "teamId" text NOT NULL,
    "isDefault" boolean DEFAULT false NOT NULL
);


ALTER TABLE public."Domain" OWNER TO shimmer_owner;

--
-- Name: Feedback; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Feedback" (
    id text NOT NULL,
    "linkId" text NOT NULL,
    data jsonb NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Feedback" OWNER TO shimmer_owner;

--
-- Name: FeedbackResponse; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."FeedbackResponse" (
    id text NOT NULL,
    "feedbackId" text NOT NULL,
    data jsonb NOT NULL,
    "viewId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."FeedbackResponse" OWNER TO shimmer_owner;

--
-- Name: Folder; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Folder" (
    id text NOT NULL,
    name text NOT NULL,
    path text NOT NULL,
    "parentId" text,
    "teamId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Folder" OWNER TO shimmer_owner;

--
-- Name: IncomingWebhook; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."IncomingWebhook" (
    id text NOT NULL,
    "externalId" text NOT NULL,
    name text NOT NULL,
    secret text,
    source text,
    actions text,
    "consecutiveFailures" integer DEFAULT 0 NOT NULL,
    "lastFailedAt" timestamp(3) without time zone,
    "disabledAt" timestamp(3) without time zone,
    "teamId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."IncomingWebhook" OWNER TO shimmer_owner;

--
-- Name: Invitation; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Invitation" (
    email text NOT NULL,
    expires timestamp(3) without time zone NOT NULL,
    "teamId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    token text NOT NULL
);


ALTER TABLE public."Invitation" OWNER TO shimmer_owner;

--
-- Name: Link; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Link" (
    id text NOT NULL,
    "documentId" text,
    url text,
    name text,
    slug text,
    "expiresAt" timestamp(3) without time zone,
    password text,
    "emailProtected" boolean DEFAULT true NOT NULL,
    "isArchived" boolean DEFAULT false NOT NULL,
    "domainId" text,
    "domainSlug" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "allowDownload" boolean DEFAULT false,
    "enableNotification" boolean DEFAULT true,
    "enableFeedback" boolean DEFAULT false,
    "enableCustomMetatag" boolean DEFAULT false,
    "metaDescription" text,
    "metaImage" text,
    "metaTitle" text,
    "emailAuthenticated" boolean DEFAULT false NOT NULL,
    "allowList" text[],
    "denyList" text[],
    "dataroomId" text,
    "linkType" public."LinkType" DEFAULT 'DOCUMENT_LINK'::public."LinkType" NOT NULL,
    "enableQuestion" boolean DEFAULT false,
    "enableScreenshotProtection" boolean DEFAULT false,
    "agreementId" text,
    "enableAgreement" boolean DEFAULT false,
    "showBanner" boolean DEFAULT false,
    "enableWatermark" boolean DEFAULT false,
    "watermarkConfig" jsonb,
    "audienceType" public."LinkAudienceType" DEFAULT 'GENERAL'::public."LinkAudienceType" NOT NULL,
    "groupId" text,
    "metaFavicon" text,
    "teamId" text,
    "enableConversation" boolean DEFAULT false NOT NULL,
    "enableUpload" boolean DEFAULT false,
    "isFileRequestOnly" boolean DEFAULT false,
    "uploadFolderId" text
);


ALTER TABLE public."Link" OWNER TO shimmer_owner;

--
-- Name: LinkPreset; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."LinkPreset" (
    id text NOT NULL,
    name text NOT NULL,
    "teamId" text NOT NULL,
    "enableCustomMetaTag" boolean DEFAULT false,
    "metaTitle" text,
    "metaDescription" text,
    "metaImage" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "metaFavicon" text,
    "allowDownload" boolean DEFAULT false,
    "allowList" text[],
    "denyList" text[],
    "emailAuthenticated" boolean DEFAULT false,
    "emailProtected" boolean DEFAULT true,
    "enableAllowList" boolean DEFAULT false,
    "enableDenyList" boolean DEFAULT false,
    "enablePassword" boolean DEFAULT false,
    "enableWatermark" boolean DEFAULT false,
    "expiresAt" timestamp(3) without time zone,
    "expiresIn" integer,
    "isDefault" boolean DEFAULT false NOT NULL,
    "pId" text,
    password text,
    "watermarkConfig" jsonb,
    "agreementId" text,
    "customFields" jsonb,
    "enableAgreement" boolean DEFAULT false,
    "enableCustomFields" boolean DEFAULT false,
    "enableScreenshotProtection" boolean DEFAULT false
);


ALTER TABLE public."LinkPreset" OWNER TO shimmer_owner;

--
-- Name: Message; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Message" (
    id text NOT NULL,
    content text NOT NULL,
    "conversationId" text NOT NULL,
    "userId" text,
    "viewerId" text,
    "viewId" text,
    "isRead" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Message" OWNER TO shimmer_owner;

--
-- Name: Reaction; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Reaction" (
    id text NOT NULL,
    "viewId" text NOT NULL,
    "pageNumber" integer NOT NULL,
    type text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Reaction" OWNER TO shimmer_owner;

--
-- Name: RestrictedToken; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."RestrictedToken" (
    id text NOT NULL,
    name text NOT NULL,
    "hashedKey" text NOT NULL,
    "partialKey" text NOT NULL,
    scopes text,
    expires timestamp(3) without time zone,
    "lastUsed" timestamp(3) without time zone,
    "rateLimit" integer DEFAULT 60 NOT NULL,
    "userId" text NOT NULL,
    "teamId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."RestrictedToken" OWNER TO shimmer_owner;

--
-- Name: SentEmail; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."SentEmail" (
    id text NOT NULL,
    type public."EmailType" NOT NULL,
    recipient text NOT NULL,
    marketing boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "teamId" text NOT NULL,
    "domainSlug" text
);


ALTER TABLE public."SentEmail" OWNER TO shimmer_owner;

--
-- Name: Session; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Session" (
    id text NOT NULL,
    "sessionToken" text NOT NULL,
    "userId" text NOT NULL,
    expires timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Session" OWNER TO shimmer_owner;

--
-- Name: Tag; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Tag" (
    id text NOT NULL,
    name text NOT NULL,
    color text NOT NULL,
    description text,
    "teamId" text NOT NULL,
    "createdBy" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Tag" OWNER TO shimmer_owner;

--
-- Name: TagItem; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."TagItem" (
    id text NOT NULL,
    "tagId" text NOT NULL,
    "linkId" text,
    "documentId" text,
    "dataroomId" text,
    "taggedBy" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "itemType" public."TagType" NOT NULL
);


ALTER TABLE public."TagItem" OWNER TO shimmer_owner;

--
-- Name: Team; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Team" (
    id text NOT NULL,
    name text NOT NULL,
    plan text DEFAULT 'free'::text NOT NULL,
    "stripeId" text,
    "subscriptionId" text,
    "startsAt" timestamp(3) without time zone,
    "endsAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    limits jsonb
);


ALTER TABLE public."Team" OWNER TO shimmer_owner;

--
-- Name: User; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."User" (
    id text NOT NULL,
    name text,
    email text,
    "emailVerified" timestamp(3) without time zone,
    image text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    plan text DEFAULT 'free'::text NOT NULL,
    "stripeId" text,
    "subscriptionId" text,
    "startsAt" timestamp(3) without time zone,
    "endsAt" timestamp(3) without time zone,
    "contactId" text
);


ALTER TABLE public."User" OWNER TO shimmer_owner;

--
-- Name: UserTeam; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."UserTeam" (
    role public."Role" DEFAULT 'MEMBER'::public."Role" NOT NULL,
    "userId" text NOT NULL,
    "teamId" text NOT NULL,
    "notificationPreferences" jsonb
);


ALTER TABLE public."UserTeam" OWNER TO shimmer_owner;

--
-- Name: VerificationToken; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."VerificationToken" (
    identifier text NOT NULL,
    token text NOT NULL,
    expires timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."VerificationToken" OWNER TO shimmer_owner;

--
-- Name: View; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."View" (
    id text NOT NULL,
    "linkId" text NOT NULL,
    "documentId" text,
    "viewerEmail" text,
    "viewedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    verified boolean DEFAULT false NOT NULL,
    "downloadedAt" timestamp(3) without time zone,
    "dataroomId" text,
    "dataroomViewId" text,
    "viewType" public."ViewType" DEFAULT 'DOCUMENT_VIEW'::public."ViewType" NOT NULL,
    "viewerId" text,
    "viewerName" text,
    "groupId" text,
    "teamId" text,
    "isArchived" boolean DEFAULT false NOT NULL
);


ALTER TABLE public."View" OWNER TO shimmer_owner;

--
-- Name: Viewer; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Viewer" (
    id text NOT NULL,
    email text NOT NULL,
    verified boolean DEFAULT false NOT NULL,
    "invitedAt" timestamp(3) without time zone,
    "dataroomId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "teamId" text NOT NULL,
    "notificationPreferences" jsonb
);


ALTER TABLE public."Viewer" OWNER TO shimmer_owner;

--
-- Name: ViewerGroup; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."ViewerGroup" (
    id text NOT NULL,
    name text NOT NULL,
    "dataroomId" text NOT NULL,
    "teamId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "allowAll" boolean DEFAULT false NOT NULL,
    domains text[]
);


ALTER TABLE public."ViewerGroup" OWNER TO shimmer_owner;

--
-- Name: ViewerGroupAccessControls; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."ViewerGroupAccessControls" (
    id text NOT NULL,
    "groupId" text NOT NULL,
    "itemId" text NOT NULL,
    "itemType" public."ItemType" NOT NULL,
    "canView" boolean DEFAULT true NOT NULL,
    "canDownload" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."ViewerGroupAccessControls" OWNER TO shimmer_owner;

--
-- Name: ViewerGroupMembership; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."ViewerGroupMembership" (
    id text NOT NULL,
    "viewerId" text NOT NULL,
    "groupId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."ViewerGroupMembership" OWNER TO shimmer_owner;

--
-- Name: Webhook; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."Webhook" (
    id text NOT NULL,
    "pId" text NOT NULL,
    name text NOT NULL,
    url text NOT NULL,
    secret text NOT NULL,
    triggers jsonb NOT NULL,
    "teamId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Webhook" OWNER TO shimmer_owner;

--
-- Name: YearInReview; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public."YearInReview" (
    id text NOT NULL,
    "teamId" text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    "lastAttempted" timestamp(3) without time zone,
    error text,
    stats jsonb NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."YearInReview" OWNER TO shimmer_owner;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: shimmer_owner
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO shimmer_owner;

--
-- Data for Name: Account; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Account" (id, "userId", type, provider, "providerAccountId", refresh_token, access_token, expires_at, token_type, scope, id_token, session_state) FROM stdin;
\.


--
-- Data for Name: Agreement; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Agreement" (id, name, content, "teamId", "createdAt", "updatedAt", "requireName", "deletedAt", "deletedBy") FROM stdin;
\.


--
-- Data for Name: AgreementResponse; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."AgreementResponse" (id, "agreementId", "viewId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Brand; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Brand" (id, logo, "brandColor", "accentColor", "teamId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Chat; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Chat" (id, "threadId", "userId", "documentId", "createdAt", "lastMessageAt") FROM stdin;
\.


--
-- Data for Name: Conversation; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Conversation" (id, title, "isEnabled", "visibilityMode", "dataroomId", "dataroomDocumentId", "documentVersionNumber", "documentPageNumber", "linkId", "viewerGroupId", "initialViewId", "lastMessageAt", "createdAt", "updatedAt", "teamId") FROM stdin;
\.


--
-- Data for Name: ConversationParticipant; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."ConversationParticipant" (id, "conversationId", role, "viewerId", "userId", "receiveNotifications", "createdAt") FROM stdin;
\.


--
-- Data for Name: ConversationView; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."ConversationView" (id, "conversationId", "viewId", "createdAt") FROM stdin;
\.


--
-- Data for Name: CustomField; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."CustomField" (id, "createdAt", "updatedAt", type, identifier, label, placeholder, required, disabled, "linkId", "orderIndex") FROM stdin;
\.


--
-- Data for Name: CustomFieldResponse; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."CustomFieldResponse" (id, data, "viewId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Dataroom; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Dataroom" (id, "pId", name, "teamId", "createdAt", "updatedAt", "conversationsEnabled", description) FROM stdin;
\.


--
-- Data for Name: DataroomBrand; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."DataroomBrand" (id, logo, banner, "brandColor", "accentColor", "dataroomId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: DataroomDocument; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."DataroomDocument" (id, "dataroomId", "documentId", "folderId", "createdAt", "updatedAt", "orderIndex") FROM stdin;
\.


--
-- Data for Name: DataroomFolder; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."DataroomFolder" (id, name, path, "parentId", "dataroomId", "createdAt", "updatedAt", "orderIndex") FROM stdin;
\.


--
-- Data for Name: Document; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Document" (id, name, description, file, type, "numPages", "ownerId", "createdAt", "updatedAt", "teamId", "assistantEnabled", "storageType", "folderId", "advancedExcelEnabled", "contentType", "originalFile", "downloadOnly", "isExternalUpload") FROM stdin;
\.


--
-- Data for Name: DocumentPage; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."DocumentPage" (id, "versionId", "pageNumber", file, "createdAt", "updatedAt", "embeddedLinks", "storageType", metadata, "pageLinks") FROM stdin;
\.


--
-- Data for Name: DocumentUpload; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."DocumentUpload" (id, "documentId", "teamId", "viewerId", "viewId", "linkId", "dataroomId", "dataroomDocumentId", "originalFilename", "fileSize", "mimeType", "uploadedAt", "createdAt", "updatedAt", "numPages") FROM stdin;
\.


--
-- Data for Name: DocumentVersion; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."DocumentVersion" (id, "versionNumber", "documentId", file, type, "numPages", "isPrimary", "createdAt", "updatedAt", "hasPages", "fileId", "storageType", "isVertical", "contentType", "originalFile", "fileSize", length) FROM stdin;
\.


--
-- Data for Name: Domain; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Domain" (id, slug, "userId", verified, "lastChecked", "createdAt", "updatedAt", "teamId", "isDefault") FROM stdin;
\.


--
-- Data for Name: Feedback; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Feedback" (id, "linkId", data, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: FeedbackResponse; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."FeedbackResponse" (id, "feedbackId", data, "viewId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Folder; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Folder" (id, name, path, "parentId", "teamId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: IncomingWebhook; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."IncomingWebhook" (id, "externalId", name, secret, source, actions, "consecutiveFailures", "lastFailedAt", "disabledAt", "teamId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Invitation; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Invitation" (email, expires, "teamId", "createdAt", token) FROM stdin;
\.


--
-- Data for Name: Link; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Link" (id, "documentId", url, name, slug, "expiresAt", password, "emailProtected", "isArchived", "domainId", "domainSlug", "createdAt", "updatedAt", "allowDownload", "enableNotification", "enableFeedback", "enableCustomMetatag", "metaDescription", "metaImage", "metaTitle", "emailAuthenticated", "allowList", "denyList", "dataroomId", "linkType", "enableQuestion", "enableScreenshotProtection", "agreementId", "enableAgreement", "showBanner", "enableWatermark", "watermarkConfig", "audienceType", "groupId", "metaFavicon", "teamId", "enableConversation", "enableUpload", "isFileRequestOnly", "uploadFolderId") FROM stdin;
\.


--
-- Data for Name: LinkPreset; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."LinkPreset" (id, name, "teamId", "enableCustomMetaTag", "metaTitle", "metaDescription", "metaImage", "createdAt", "updatedAt", "metaFavicon", "allowDownload", "allowList", "denyList", "emailAuthenticated", "emailProtected", "enableAllowList", "enableDenyList", "enablePassword", "enableWatermark", "expiresAt", "expiresIn", "isDefault", "pId", password, "watermarkConfig", "agreementId", "customFields", "enableAgreement", "enableCustomFields", "enableScreenshotProtection") FROM stdin;
\.


--
-- Data for Name: Message; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Message" (id, content, "conversationId", "userId", "viewerId", "viewId", "isRead", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Reaction; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Reaction" (id, "viewId", "pageNumber", type, "createdAt") FROM stdin;
\.


--
-- Data for Name: RestrictedToken; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."RestrictedToken" (id, name, "hashedKey", "partialKey", scopes, expires, "lastUsed", "rateLimit", "userId", "teamId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: SentEmail; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."SentEmail" (id, type, recipient, marketing, "createdAt", "teamId", "domainSlug") FROM stdin;
\.


--
-- Data for Name: Session; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Session" (id, "sessionToken", "userId", expires) FROM stdin;
\.


--
-- Data for Name: Tag; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Tag" (id, name, color, description, "teamId", "createdBy", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: TagItem; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."TagItem" (id, "tagId", "linkId", "documentId", "dataroomId", "taggedBy", "createdAt", "updatedAt", "itemType") FROM stdin;
\.


--
-- Data for Name: Team; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Team" (id, name, plan, "stripeId", "subscriptionId", "startsAt", "endsAt", "createdAt", "updatedAt", limits) FROM stdin;
cmahan91600010nawrtig5kl0	Personal Team	free	\N	\N	\N	\N	2025-05-09 21:13:59.419	2025-05-09 21:13:59.419	\N
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."User" (id, name, email, "emailVerified", image, "createdAt", plan, "stripeId", "subscriptionId", "startsAt", "endsAt", "contactId") FROM stdin;
cmahan66a00000naw8wzx0kv5	\N	jay@dreamable.com	2025-05-09 21:13:55.712	\N	2025-05-09 21:13:55.714	free	\N	\N	\N	\N	\N
\.


--
-- Data for Name: UserTeam; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."UserTeam" (role, "userId", "teamId", "notificationPreferences") FROM stdin;
ADMIN	cmahan66a00000naw8wzx0kv5	cmahan91600010nawrtig5kl0	\N
\.


--
-- Data for Name: VerificationToken; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."VerificationToken" (identifier, token, expires) FROM stdin;
\.


--
-- Data for Name: View; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."View" (id, "linkId", "documentId", "viewerEmail", "viewedAt", verified, "downloadedAt", "dataroomId", "dataroomViewId", "viewType", "viewerId", "viewerName", "groupId", "teamId", "isArchived") FROM stdin;
\.


--
-- Data for Name: Viewer; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Viewer" (id, email, verified, "invitedAt", "dataroomId", "createdAt", "updatedAt", "teamId", "notificationPreferences") FROM stdin;
\.


--
-- Data for Name: ViewerGroup; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."ViewerGroup" (id, name, "dataroomId", "teamId", "createdAt", "updatedAt", "allowAll", domains) FROM stdin;
\.


--
-- Data for Name: ViewerGroupAccessControls; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."ViewerGroupAccessControls" (id, "groupId", "itemId", "itemType", "canView", "canDownload", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: ViewerGroupMembership; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."ViewerGroupMembership" (id, "viewerId", "groupId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Webhook; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."Webhook" (id, "pId", name, url, secret, triggers, "teamId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: YearInReview; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public."YearInReview" (id, "teamId", status, attempts, "lastAttempted", error, stats, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: shimmer_owner
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
a13d0ac6-4aad-4fb2-83cd-25f33a5f2df0	0a11092d8734c7a5a1a668fd04b4c75520b4f83b8dbbd6eb64b1e2f6d56d8bdd	2025-05-09 21:10:36.161036+00	20240611000000_add_agreements	\N	\N	2025-05-09 21:10:35.641782+00	1
93838d91-9507-473a-925e-ca924a359e5d	ec54370c3928a7b24a33343dfe3a329da46ca44b207c826af7d4c803482d77ba	2025-05-09 21:10:14.380596+00	20230912150657_initialize	\N	\N	2025-05-09 21:10:13.854934+00	1
0b933ead-1963-47d6-915f-1406df37528d	2efcd1b9557dac35436b7515cd9c71d8268464abfe969007aa160381d9377a1f	2025-05-09 21:10:23.919645+00	20240110233134_add_disable_feedback	\N	\N	2025-05-09 21:10:23.392653+00	1
7746cfc8-04e4-4311-80c7-d2f6aa5c62ae	b166f7a27e0a2af4ee12a630c16877f13a31618945129fee8eb61408af00884a	2025-05-09 21:10:15.088675+00	202310122339_NewColumnInLinkTable	\N	\N	2025-05-09 21:10:14.556801+00	1
1b36fd22-444a-450a-86ce-10a580299ef2	34996c5c3665bc38517171dac61eb579cf933d7e140dfb3821f0c51a40730709	2025-05-09 21:10:15.872318+00	20231013165123_create_document_version	\N	\N	2025-05-09 21:10:15.347159+00	1
635eeb58-7fd3-4c64-92c4-6e969dfe93b8	3d7f16effb70aa4fac8af2a83c62b9e49298b1707d212f546e1654f1e4841654	2025-05-09 21:10:29.5868+00	20240327102407_add_dataroom	\N	\N	2025-05-09 21:10:29.064831+00	1
61039af4-9288-4f9d-b733-90a6eaf9ec44	301910844f2f5e81341f279b503d1c1c775b88dccffe35f1101865ef22da3b8f	2025-05-09 21:10:16.574198+00	20231014200337_create_document_pages	\N	\N	2025-05-09 21:10:16.049941+00	1
11c2a36b-d5ae-4a88-aeea-b83add396dac	80d829a0e930938b49abe33d50e1cbfe94dc6eb4d2f21aa2b6263355dc101488	2025-05-09 21:10:24.621076+00	20240117020456_add_branding	\N	\N	2025-05-09 21:10:24.104371+00	1
c1a57150-77e6-465e-b51e-810c8ca407d3	0b579fe78abe7435fb159cea1b508e6bf425a7b1eda3d103aad3e97e64f7d342	2025-05-09 21:10:17.29735+00	202310311254_NewColumnEnableNotificationLinkTable	\N	\N	2025-05-09 21:10:16.752977+00	1
84ba2c03-0c72-4bef-bbbd-006ddbc7d5d7	0c2997fad7f9c822d29ecf66bee50e931b64dbb41d145bd0dafdc2ae52245247	2025-05-09 21:10:18.060419+00	20231105152632_create_team	\N	\N	2025-05-09 21:10:17.526603+00	1
af94ad85-6a5d-4876-b29b-1ae4fc01afda	2cfc46ccfc34676c91c82453fd7e08ae2acb7c77ed9d640afadc7b3dbe82a238	2025-05-09 21:10:18.769242+00	20231113051339_create_sent_email	\N	\N	2025-05-09 21:10:18.238667+00	1
84e64b17-1844-4ebf-a1f6-60c4afd868e1	d5aebba19fdd03310f139851091c433e9349c138d8b67137b5662012cb7eaf7c	2025-05-09 21:10:25.306528+00	20240202052149_add_email_authentication_to_link_and_view	\N	\N	2025-05-09 21:10:24.871703+00	1
7ed2ccad-ad23-41c6-bff3-b1b10bdf2700	eac09a6f2565a8f7c0b19882143de84af2d44c0b693cb8ee78e529458b713e2b	2025-05-09 21:10:19.449206+00	20231114054509_add_domain_to_sent_emails	\N	\N	2025-05-09 21:10:19.014626+00	1
6f750fdd-4549-46c1-a5eb-d271280211a2	e389264fc14ec9a82c002c6a6c854747cc692e8919b68a467072295564c34985	2025-05-09 21:10:20.23625+00	20231116093816_update_invitations	\N	\N	2025-05-09 21:10:19.714783+00	1
8150eed0-f943-4587-a403-dcf711fff7a2	2c58741ff895482de57bd1007a6fa1058ba1a1e66277ce2c9d0d422c10984086	2025-05-09 21:10:33.885807+00	20240511000000_add_team_limits	\N	\N	2025-05-09 21:10:33.357079+00	1
9a436086-c5a8-4905-bace-3bfbab7190d2	3e0478a93769ff3493ac9236c32d63ea01b928c6fd79b76fa63dc0946a7b7c31	2025-05-09 21:10:20.943755+00	20231127062841_add_conversation	\N	\N	2025-05-09 21:10:20.41403+00	1
b98cb332-5da1-4179-9079-38ffc1ecc26d	db49252e3a36ed2ac7492f3906ac814a833d4a1957b34b640bbcdc826b907ea3	2025-05-09 21:10:26.008771+00	20240205170242_embedded_links	\N	\N	2025-05-09 21:10:25.480752+00	1
688b25ba-5d63-4efb-8fb9-042bed03c2c8	6a22a79906cc7513c22a84deedf01dc7f7f14112169a4f9dd844d367350f9e18	2025-05-09 21:10:21.738221+00	20231128064540_add_indices	\N	\N	2025-05-09 21:10:21.202395+00	1
d8a6cede-3e5c-4108-b709-64d3d5a3f297	7a1e91fc454d11fd8544510786c310c42691bc4d21c181cbd96a25a67eb86138	2025-05-09 21:10:22.431127+00	20231204070250_remove_trial	\N	\N	2025-05-09 21:10:21.91886+00	1
8e2612c7-4ee8-4f24-8811-ef8276fd5c5f	4ab23c4c2991352aa5b0e9db465be8224f43aece9a85940da1774a45d9e9804b	2025-05-09 21:10:30.201329+00	20240330062000_add_viewtype	\N	\N	2025-05-09 21:10:29.75638+00	1
0ae1924f-a7f0-4e7c-a6bd-5dd201a24b88	e4a459f924ff05a48ef7713cd50f01cc10a5d23fefa466c9fe339601487bee02	2025-05-09 21:10:23.209904+00	20231207081407_add_reactions	\N	\N	2025-05-09 21:10:22.685789+00	1
d16fe750-7d45-499b-978d-9fcd93f354e7	b4324d11eb9b68a4eb1a3598376164f366bbb98f7f050e2f276ad28f2de606fb	2025-05-09 21:10:26.699544+00	20240212081614_add_downloaded_time_to_view	\N	\N	2025-05-09 21:10:26.180211+00	1
f1f28d3c-c775-408a-ad92-6e7d9ffec458	cfc6f0ff3be30a5d7c93b7d5df3d288199f8830e08a47dd2937fe0f3a04f52cc	2025-05-09 21:10:27.403533+00	20240215035046_add_allow_deny_list_to_links	\N	\N	2025-05-09 21:10:26.879634+00	1
914be5c1-92c0-4ae5-83d0-f7be1dd246e6	3af7cf8d95d80e896f21e9d8393f4b2da5790338c2e01399e1fbb7faf2558655	2025-05-09 21:10:28.108741+00	20240221042933_add_document_storage_type_enum	\N	\N	2025-05-09 21:10:27.580055+00	1
d464e5d5-7cf5-4f31-af91-3dd2c75952f1	544512f6c0333cce7e984d983ac7707fb23f485133312db3717a0ac7ffe0fd7a	2025-05-09 21:10:30.896424+00	20240401000000_add_dataroom_brand	\N	\N	2025-05-09 21:10:30.374985+00	1
8a568b9b-2417-4902-9c02-9be972ccde38	b21972f95259485e1ce417d7edd4eeb0c406c4b2446daf5344ac52fd5c236f68	2025-05-09 21:10:28.830935+00	20240313100203_add_folders	\N	\N	2025-05-09 21:10:28.291351+00	1
b4136909-a380-444f-b313-4c6ce61915cc	20ab412fc67af0dbc171c0bff0a98c9b6c0998ebfbc507e399fd952194f19c61	2025-05-09 21:10:31.684653+00	20240408000000_add_viewer	\N	\N	2025-05-09 21:10:31.160128+00	1
0cdfcea3-541a-4169-913e-ef114036d23d	2fc6684472c04d79e232bfa2711f93a2c4de76860c24d65fdf3f82b048b97140	2025-05-09 21:10:34.606533+00	20240520000000_add_vertical_to_document_version	\N	\N	2025-05-09 21:10:34.074173+00	1
e3d4fd6f-43ff-4b93-96df-451378d26221	c250aa46f35a3f4cde1c891d4cf90c5615b4016bec20e85a375abf51f350d84c	2025-05-09 21:10:32.410493+00	20240415000000_add_feedback	\N	\N	2025-05-09 21:10:31.862561+00	1
36563ff7-25f1-4c69-94f6-0baa7e7375da	2c4e79e64ec644258c12061b3eed4cebeed66d3154975921dceb67d66158cfdc	2025-05-09 21:10:33.170718+00	20240424152839_add_screenprotection_to_link	\N	\N	2025-05-09 21:10:32.649707+00	1
4332b2b2-baa1-4591-8538-ea0e9ae3da68	b11c40b63209f66371fc87e4166f5ac488d0c79424995ae9dfabebf60af73c79	2025-05-09 21:10:39.110786+00	20240731000000_add_link_show_banner	\N	\N	2025-05-09 21:10:38.590228+00	1
9cb8a1e7-dc02-4910-b9a5-85ebe7f1bf60	f671046e09b1c1e7bae4397d858458d5ac388ea4ffd9100f234b94577ab7999f	2025-05-09 21:10:35.443011+00	20240521000000_add_manager_role	\N	\N	2025-05-09 21:10:34.921802+00	1
d05a506f-cee6-4acc-ad96-c9a9a42896c9	fc0fcb9d7f42fa07f2095b050788c918f4368b979b0502f2bbcdf388b0655dcf	2025-05-09 21:10:38.413737+00	20240730000000_update_link_defaults	\N	\N	2025-05-09 21:10:37.889088+00	1
97516f06-68fa-48f1-a441-36045ee54868	aece9ca79ebc5738ca1fc8ec77c94294d8653d4b18d52b4dad9d1bc6769fe286	2025-05-09 21:10:36.936068+00	20240712000000_add_page_metadata	\N	\N	2025-05-09 21:10:36.402477+00	1
1a7c17d4-88e9-4050-8053-00ac9443f2aa	439c88796b3ac411ce468a79f380a9a678cfd5aee22fe531a6f0dd4a5b96f114	2025-05-09 21:10:37.656993+00	20240720000000_change_owner_dependecy	\N	\N	2025-05-09 21:10:37.117016+00	1
7bea1acb-4ac7-4a25-8e9e-611eed410da5	96d1e9994e263c359957b6386dd8dcbb180eb3478b60881f5c3d8961bb28c031	2025-05-09 21:10:39.831801+00	20240809000000_add_dataroom_order_index	\N	\N	2025-05-09 21:10:39.292062+00	1
3082ba1c-ce01-43f2-b993-2b9c61e7fba0	156ad3018fe575ae0c183d196c3342a21e125159a5c184863355a6b00834c51f	2025-05-09 21:10:40.603638+00	20240821000000_add_require_name	\N	\N	2025-05-09 21:10:40.07945+00	1
5021bd79-701c-4287-abec-e14c2771678d	db09801dad86c164de8193f79379d23d8eb002e16d393dbe2c98ef8963c6054a	2025-05-09 21:10:41.337254+00	20240830000000_add_watermarks	\N	\N	2025-05-09 21:10:40.774859+00	1
0ce5960a-2f05-4e44-9648-04a93929aea8	1bfb2ad94a33dd34a1b43dd96ea4a7a90b6dbacbc675b8e26cbc9f5e05a72249	2025-05-09 21:10:42.083769+00	20240901000000_add_domain_default	\N	\N	2025-05-09 21:10:41.562514+00	1
f7ac7274-e182-4465-9308-dd6928a8d35b	428ca61bfb3f3ee37c3ce398080a4cecaa1c7e8c0e65a4271f1e52c1c14f170d	2025-05-09 21:10:42.80657+00	20240902000000_add_link_presets	\N	\N	2025-05-09 21:10:42.266561+00	1
3d79b4d6-1eda-450d-88f5-d7e1a06e420b	07e6c8322f5d9c681592c0e920fda746d7db378dbe32e3362f71cd5b6b8887b2	2025-05-09 21:10:43.500142+00	20240911000000_add_dataroom_groups_permissions	\N	\N	2025-05-09 21:10:42.979681+00	1
5d3a1664-fefd-4f8c-9525-399320f859d1	bd24fd7ef9e273b0cbbd01bc43c459112949fe3e70042a14a0f77d25c9b1be2a	2025-05-09 21:10:52.93826+00	20250110000000_add_length_to_document_version	\N	\N	2025-05-09 21:10:52.42512+00	1
a8332d9e-00d9-445d-a404-1bc8c4d404f9	65b68b11d99cc61480d247eb14862e7b15be13f592eec815a9bae54a3d70d868	2025-05-09 21:10:44.260598+00	20240915000000_add_advanced_mode	\N	\N	2025-05-09 21:10:43.744617+00	1
1603a067-c988-4177-9e29-bd1620ac059e	1986fc8b6c18cc4d12bd2762370305ea0ed1f8674509b314394f35af650f40ba	2025-05-09 21:10:44.96596+00	20240916000000_add_content_type_to_document	\N	\N	2025-05-09 21:10:44.437741+00	1
2547850a-2d4e-4dcb-966e-29f9906c81e4	f3270406d4bea1d72f27cfe534a882105d8a49c86dcf49402f99952cbf955a34	2025-05-09 21:10:58.859394+00	20250425000000_update_link_presets	\N	\N	2025-05-09 21:10:58.335582+00	1
8a20dd88-95bb-4540-a6fc-3652debd6cd0	a96102b9f8aeeaeaa76faeda7f3cdda90d88138ba2644e2e7c21c71ba6ac6dbb	2025-05-09 21:10:45.754038+00	20240921000000_add_viewer_migration	\N	\N	2025-05-09 21:10:45.230731+00	1
80908629-795a-4e04-9a42-217d239d68f4	10e383537f989362b0b1ec0c74f0f9fb4e043bcaf6bd717236c2ebbf5b6243b1	2025-05-09 21:10:53.711118+00	20250113000000_add_custom_fields	\N	\N	2025-05-09 21:10:53.182382+00	1
6fb62f38-03f7-4977-9abf-1507b025ba07	6dff87c63f1d180138e6164a14097739189bb896e246d190e9fe9dc31ac5afe4	2025-05-09 21:10:46.450998+00	20241004024010_add_favicon_column	\N	\N	2025-05-09 21:10:45.926286+00	1
a958e91f-e08e-4729-86c0-ac048c4909b0	76f289ec487552c85995236e82984f64dd5ff28d48d5aef942d20e59bd6f6487	2025-05-09 21:10:47.158027+00	20241020000000_add_teamid_to_link_and_view	\N	\N	2025-05-09 21:10:46.652022+00	1
f2fe8547-0ba9-4932-bd6f-f24ef611aad4	1590494e3fcb0dd9719cdee4420f977b79019db88f904bf72b414c43e2122b8f	2025-05-09 21:10:47.939724+00	20241029000000_add_archived_view	\N	\N	2025-05-09 21:10:47.423528+00	1
14687be2-8c4d-4742-bef2-41c1246880e6	3bc823dfb7884ddf23d64ec818b67341a02b4590ef60de68ac3774299247845e	2025-05-09 21:10:54.403223+00	20250204000000_add_anonymous_group	\N	\N	2025-05-09 21:10:53.888844+00	1
c6ba5b13-18ed-4f82-8c44-f12247466cc3	c659ed89855ff3e98accfcb01ccf8088717ce2cbcca3574b76e3ac798ca87c9b	2025-05-09 21:10:48.653438+00	20241107000000_add_tokens_and_webhooks	\N	\N	2025-05-09 21:10:48.119732+00	1
c6ec40ae-66ed-47ec-a1eb-b8a0abb9a4a2	aa1217975be4d1fd0cfc6a18c8ed747279e942e5a000838e6fb166418570af96	2025-05-09 21:10:49.331771+00	20241118000000_add_filesize_and_downloadonly	\N	\N	2025-05-09 21:10:48.900425+00	1
0b7d01d8-d6dd-4504-b08e-fdb8d02b0d23	598da8b98443c077a76e6224cd3eff0f5069c1152032a7fa9d60d529a1eb0c45	2025-05-09 21:10:50.037068+00	20241123000000_add_viewer_notification_preferences	\N	\N	2025-05-09 21:10:49.532625+00	1
371030e4-ff3e-433e-90c9-a93daebf7156	1d20de6655c9a06d557d754f56d5477d55d76902e14e2b69b11d5c808e5d5330	2025-05-09 21:10:55.039201+00	20250217000000_add_contactid_to_user	\N	\N	2025-05-09 21:10:54.572967+00	1
90b5d537-7ea6-4b76-b049-ca1671e2a596	e2939eda71037d2a7224b0214d6848431c668c4d5561fdb661f824dd2009cd01	2025-05-09 21:10:50.760045+00	20241126000000_add_screen_shield	\N	\N	2025-05-09 21:10:50.222091+00	1
59d066d3-f30c-45dd-a871-640a5ef86b50	fd22888e628f9646e8bc0ecf970e56691490d119db42843116db8de74669576c	2025-05-09 21:10:51.520883+00	20241208000000_add_webhooks	\N	\N	2025-05-09 21:10:50.99631+00	1
8cfbc3b3-9788-47b1-88c1-f4708fb9ff34	0fffa9cdf5713df7fdb29be04c1c0ec6160c56bcd09d7c36a7bf2667c09c6864	2025-05-09 21:10:59.565554+00	20250428000000_add_tags	\N	\N	2025-05-09 21:10:59.037915+00	1
88dadb95-d052-4889-b1ae-6502d629ce68	8a826c618129c9a88d0011c3fc64445cde61e4dccaea2d965fe493157309b2ce	2025-05-09 21:10:52.243205+00	20241212000000_add_yir	\N	\N	2025-05-09 21:10:51.725131+00	1
1fbd52e4-cd69-4d89-b586-66e92c474561	df56e309a31fda56df5cb87e560bca02ce133a67f90f6067e45be50aeaaf0a05	2025-05-09 21:10:55.802534+00	20250217000000_remove_link_column	\N	\N	2025-05-09 21:10:55.280906+00	1
b0aa5cd3-e380-474d-9362-5b528c9e3b98	d2929ce435596ebd006efaaef2418468813d56df9bdcd1961053a93aa369d851	2025-05-09 21:10:56.518252+00	20250310000000_rename_conversation_table	\N	\N	2025-05-09 21:10:55.978231+00	1
44741d9a-5159-4b6e-a7a4-aa928cc200e2	a081cf850d414e851126bad76da4442ee59201c01d94c8bc1b54dfedbc50328c	2025-05-09 21:10:57.340071+00	20250404000000_add_questions_answer_conversation	\N	\N	2025-05-09 21:10:56.765285+00	1
a30c4631-2530-4474-80d3-d17c3319d6b3	40b11edcda090bb95b1f49b70481c810cf54de98bc9b74e152029bd9d5e31cc4	2025-05-09 21:11:00.251797+00	20250502000000_add_additional_present_fields	\N	\N	2025-05-09 21:10:59.752484+00	1
92e5967c-c1f7-4a93-b73f-5301418a3c3e	5639b10ba9f3c1ef341d2dcccf639b743f6ed134f6b0a4d6e0dc8218212cb7c3	2025-05-09 21:10:58.1062+00	20250413000000_add_dataroom_upload	\N	\N	2025-05-09 21:10:57.553911+00	1
\.


--
-- Name: Account Account_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_pkey" PRIMARY KEY (id);


--
-- Name: AgreementResponse AgreementResponse_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."AgreementResponse"
    ADD CONSTRAINT "AgreementResponse_pkey" PRIMARY KEY (id);


--
-- Name: Agreement Agreement_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Agreement"
    ADD CONSTRAINT "Agreement_pkey" PRIMARY KEY (id);


--
-- Name: Brand Brand_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Brand"
    ADD CONSTRAINT "Brand_pkey" PRIMARY KEY (id);


--
-- Name: Chat Chat_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Chat"
    ADD CONSTRAINT "Chat_pkey" PRIMARY KEY (id);


--
-- Name: ConversationParticipant ConversationParticipant_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."ConversationParticipant"
    ADD CONSTRAINT "ConversationParticipant_pkey" PRIMARY KEY (id);


--
-- Name: ConversationView ConversationView_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."ConversationView"
    ADD CONSTRAINT "ConversationView_pkey" PRIMARY KEY (id);


--
-- Name: Conversation Conversation_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Conversation"
    ADD CONSTRAINT "Conversation_pkey" PRIMARY KEY (id);


--
-- Name: CustomFieldResponse CustomFieldResponse_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."CustomFieldResponse"
    ADD CONSTRAINT "CustomFieldResponse_pkey" PRIMARY KEY (id);


--
-- Name: CustomField CustomField_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."CustomField"
    ADD CONSTRAINT "CustomField_pkey" PRIMARY KEY (id);


--
-- Name: DataroomBrand DataroomBrand_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DataroomBrand"
    ADD CONSTRAINT "DataroomBrand_pkey" PRIMARY KEY (id);


--
-- Name: DataroomDocument DataroomDocument_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DataroomDocument"
    ADD CONSTRAINT "DataroomDocument_pkey" PRIMARY KEY (id);


--
-- Name: DataroomFolder DataroomFolder_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DataroomFolder"
    ADD CONSTRAINT "DataroomFolder_pkey" PRIMARY KEY (id);


--
-- Name: Dataroom Dataroom_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Dataroom"
    ADD CONSTRAINT "Dataroom_pkey" PRIMARY KEY (id);


--
-- Name: DocumentPage DocumentPage_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DocumentPage"
    ADD CONSTRAINT "DocumentPage_pkey" PRIMARY KEY (id);


--
-- Name: DocumentUpload DocumentUpload_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DocumentUpload"
    ADD CONSTRAINT "DocumentUpload_pkey" PRIMARY KEY (id);


--
-- Name: DocumentVersion DocumentVersion_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DocumentVersion"
    ADD CONSTRAINT "DocumentVersion_pkey" PRIMARY KEY (id);


--
-- Name: Document Document_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Document"
    ADD CONSTRAINT "Document_pkey" PRIMARY KEY (id);


--
-- Name: Domain Domain_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Domain"
    ADD CONSTRAINT "Domain_pkey" PRIMARY KEY (id);


--
-- Name: FeedbackResponse FeedbackResponse_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."FeedbackResponse"
    ADD CONSTRAINT "FeedbackResponse_pkey" PRIMARY KEY (id);


--
-- Name: Feedback Feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Feedback"
    ADD CONSTRAINT "Feedback_pkey" PRIMARY KEY (id);


--
-- Name: Folder Folder_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Folder"
    ADD CONSTRAINT "Folder_pkey" PRIMARY KEY (id);


--
-- Name: IncomingWebhook IncomingWebhook_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."IncomingWebhook"
    ADD CONSTRAINT "IncomingWebhook_pkey" PRIMARY KEY (id);


--
-- Name: LinkPreset LinkPreset_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."LinkPreset"
    ADD CONSTRAINT "LinkPreset_pkey" PRIMARY KEY (id);


--
-- Name: Link Link_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Link"
    ADD CONSTRAINT "Link_pkey" PRIMARY KEY (id);


--
-- Name: Message Message_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_pkey" PRIMARY KEY (id);


--
-- Name: Reaction Reaction_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Reaction"
    ADD CONSTRAINT "Reaction_pkey" PRIMARY KEY (id);


--
-- Name: RestrictedToken RestrictedToken_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."RestrictedToken"
    ADD CONSTRAINT "RestrictedToken_pkey" PRIMARY KEY (id);


--
-- Name: SentEmail SentEmail_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."SentEmail"
    ADD CONSTRAINT "SentEmail_pkey" PRIMARY KEY (id);


--
-- Name: Session Session_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Session"
    ADD CONSTRAINT "Session_pkey" PRIMARY KEY (id);


--
-- Name: TagItem TagItem_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."TagItem"
    ADD CONSTRAINT "TagItem_pkey" PRIMARY KEY (id);


--
-- Name: Tag Tag_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Tag"
    ADD CONSTRAINT "Tag_pkey" PRIMARY KEY (id);


--
-- Name: Team Team_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Team"
    ADD CONSTRAINT "Team_pkey" PRIMARY KEY (id);


--
-- Name: UserTeam UserTeam_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."UserTeam"
    ADD CONSTRAINT "UserTeam_pkey" PRIMARY KEY ("userId", "teamId");


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: View View_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."View"
    ADD CONSTRAINT "View_pkey" PRIMARY KEY (id);


--
-- Name: ViewerGroupAccessControls ViewerGroupAccessControls_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."ViewerGroupAccessControls"
    ADD CONSTRAINT "ViewerGroupAccessControls_pkey" PRIMARY KEY (id);


--
-- Name: ViewerGroupMembership ViewerGroupMembership_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."ViewerGroupMembership"
    ADD CONSTRAINT "ViewerGroupMembership_pkey" PRIMARY KEY (id);


--
-- Name: ViewerGroup ViewerGroup_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."ViewerGroup"
    ADD CONSTRAINT "ViewerGroup_pkey" PRIMARY KEY (id);


--
-- Name: Viewer Viewer_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Viewer"
    ADD CONSTRAINT "Viewer_pkey" PRIMARY KEY (id);


--
-- Name: Webhook Webhook_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Webhook"
    ADD CONSTRAINT "Webhook_pkey" PRIMARY KEY (id);


--
-- Name: YearInReview YearInReview_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."YearInReview"
    ADD CONSTRAINT "YearInReview_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: Account_provider_providerAccountId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON public."Account" USING btree (provider, "providerAccountId");


--
-- Name: AgreementResponse_agreementId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "AgreementResponse_agreementId_idx" ON public."AgreementResponse" USING btree ("agreementId");


--
-- Name: AgreementResponse_viewId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "AgreementResponse_viewId_idx" ON public."AgreementResponse" USING btree ("viewId");


--
-- Name: AgreementResponse_viewId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "AgreementResponse_viewId_key" ON public."AgreementResponse" USING btree ("viewId");


--
-- Name: Agreement_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Agreement_teamId_idx" ON public."Agreement" USING btree ("teamId");


--
-- Name: Brand_teamId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Brand_teamId_key" ON public."Brand" USING btree ("teamId");


--
-- Name: Chat_threadId_documentId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Chat_threadId_documentId_key" ON public."Chat" USING btree ("threadId", "documentId");


--
-- Name: Chat_threadId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Chat_threadId_idx" ON public."Chat" USING btree ("threadId");


--
-- Name: Chat_threadId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Chat_threadId_key" ON public."Chat" USING btree ("threadId");


--
-- Name: Chat_userId_documentId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Chat_userId_documentId_key" ON public."Chat" USING btree ("userId", "documentId");


--
-- Name: ConversationParticipant_conversationId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "ConversationParticipant_conversationId_idx" ON public."ConversationParticipant" USING btree ("conversationId");


--
-- Name: ConversationParticipant_conversationId_userId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "ConversationParticipant_conversationId_userId_key" ON public."ConversationParticipant" USING btree ("conversationId", "userId");


--
-- Name: ConversationParticipant_conversationId_viewerId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "ConversationParticipant_conversationId_viewerId_key" ON public."ConversationParticipant" USING btree ("conversationId", "viewerId");


--
-- Name: ConversationParticipant_userId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "ConversationParticipant_userId_idx" ON public."ConversationParticipant" USING btree ("userId");


--
-- Name: ConversationParticipant_viewerId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "ConversationParticipant_viewerId_idx" ON public."ConversationParticipant" USING btree ("viewerId");


--
-- Name: ConversationView_conversationId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "ConversationView_conversationId_idx" ON public."ConversationView" USING btree ("conversationId");


--
-- Name: ConversationView_conversationId_viewId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "ConversationView_conversationId_viewId_key" ON public."ConversationView" USING btree ("conversationId", "viewId");


--
-- Name: ConversationView_viewId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "ConversationView_viewId_idx" ON public."ConversationView" USING btree ("viewId");


--
-- Name: Conversation_dataroomDocumentId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Conversation_dataroomDocumentId_idx" ON public."Conversation" USING btree ("dataroomDocumentId");


--
-- Name: Conversation_dataroomId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Conversation_dataroomId_idx" ON public."Conversation" USING btree ("dataroomId");


--
-- Name: Conversation_initialViewId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Conversation_initialViewId_idx" ON public."Conversation" USING btree ("initialViewId");


--
-- Name: Conversation_linkId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Conversation_linkId_idx" ON public."Conversation" USING btree ("linkId");


--
-- Name: Conversation_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Conversation_teamId_idx" ON public."Conversation" USING btree ("teamId");


--
-- Name: Conversation_viewerGroupId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Conversation_viewerGroupId_idx" ON public."Conversation" USING btree ("viewerGroupId");


--
-- Name: CustomFieldResponse_viewId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "CustomFieldResponse_viewId_idx" ON public."CustomFieldResponse" USING btree ("viewId");


--
-- Name: CustomFieldResponse_viewId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "CustomFieldResponse_viewId_key" ON public."CustomFieldResponse" USING btree ("viewId");


--
-- Name: CustomField_linkId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "CustomField_linkId_idx" ON public."CustomField" USING btree ("linkId");


--
-- Name: DataroomBrand_dataroomId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "DataroomBrand_dataroomId_key" ON public."DataroomBrand" USING btree ("dataroomId");


--
-- Name: DataroomDocument_dataroomId_documentId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "DataroomDocument_dataroomId_documentId_key" ON public."DataroomDocument" USING btree ("dataroomId", "documentId");


--
-- Name: DataroomDocument_dataroomId_folderId_orderIndex_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "DataroomDocument_dataroomId_folderId_orderIndex_idx" ON public."DataroomDocument" USING btree ("dataroomId", "folderId", "orderIndex");


--
-- Name: DataroomDocument_folderId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "DataroomDocument_folderId_idx" ON public."DataroomDocument" USING btree ("folderId");


--
-- Name: DataroomFolder_dataroomId_parentId_orderIndex_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "DataroomFolder_dataroomId_parentId_orderIndex_idx" ON public."DataroomFolder" USING btree ("dataroomId", "parentId", "orderIndex");


--
-- Name: DataroomFolder_dataroomId_path_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "DataroomFolder_dataroomId_path_key" ON public."DataroomFolder" USING btree ("dataroomId", path);


--
-- Name: DataroomFolder_parentId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "DataroomFolder_parentId_idx" ON public."DataroomFolder" USING btree ("parentId");


--
-- Name: Dataroom_pId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Dataroom_pId_key" ON public."Dataroom" USING btree ("pId");


--
-- Name: Dataroom_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Dataroom_teamId_idx" ON public."Dataroom" USING btree ("teamId");


--
-- Name: DocumentPage_pageNumber_versionId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "DocumentPage_pageNumber_versionId_key" ON public."DocumentPage" USING btree ("pageNumber", "versionId");


--
-- Name: DocumentPage_versionId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "DocumentPage_versionId_idx" ON public."DocumentPage" USING btree ("versionId");


--
-- Name: DocumentUpload_dataroomDocumentId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "DocumentUpload_dataroomDocumentId_idx" ON public."DocumentUpload" USING btree ("dataroomDocumentId");


--
-- Name: DocumentUpload_dataroomId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "DocumentUpload_dataroomId_idx" ON public."DocumentUpload" USING btree ("dataroomId");


--
-- Name: DocumentUpload_documentId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "DocumentUpload_documentId_idx" ON public."DocumentUpload" USING btree ("documentId");


--
-- Name: DocumentUpload_linkId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "DocumentUpload_linkId_idx" ON public."DocumentUpload" USING btree ("linkId");


--
-- Name: DocumentUpload_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "DocumentUpload_teamId_idx" ON public."DocumentUpload" USING btree ("teamId");


--
-- Name: DocumentUpload_viewId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "DocumentUpload_viewId_idx" ON public."DocumentUpload" USING btree ("viewId");


--
-- Name: DocumentUpload_viewerId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "DocumentUpload_viewerId_idx" ON public."DocumentUpload" USING btree ("viewerId");


--
-- Name: DocumentVersion_documentId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "DocumentVersion_documentId_idx" ON public."DocumentVersion" USING btree ("documentId");


--
-- Name: DocumentVersion_versionNumber_documentId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "DocumentVersion_versionNumber_documentId_key" ON public."DocumentVersion" USING btree ("versionNumber", "documentId");


--
-- Name: Document_folderId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Document_folderId_idx" ON public."Document" USING btree ("folderId");


--
-- Name: Document_ownerId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Document_ownerId_idx" ON public."Document" USING btree ("ownerId");


--
-- Name: Document_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Document_teamId_idx" ON public."Document" USING btree ("teamId");


--
-- Name: Domain_slug_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Domain_slug_key" ON public."Domain" USING btree (slug);


--
-- Name: Domain_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Domain_teamId_idx" ON public."Domain" USING btree ("teamId");


--
-- Name: Domain_userId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Domain_userId_idx" ON public."Domain" USING btree ("userId");


--
-- Name: FeedbackResponse_feedbackId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "FeedbackResponse_feedbackId_idx" ON public."FeedbackResponse" USING btree ("feedbackId");


--
-- Name: FeedbackResponse_viewId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "FeedbackResponse_viewId_idx" ON public."FeedbackResponse" USING btree ("viewId");


--
-- Name: FeedbackResponse_viewId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "FeedbackResponse_viewId_key" ON public."FeedbackResponse" USING btree ("viewId");


--
-- Name: Feedback_linkId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Feedback_linkId_idx" ON public."Feedback" USING btree ("linkId");


--
-- Name: Feedback_linkId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Feedback_linkId_key" ON public."Feedback" USING btree ("linkId");


--
-- Name: Folder_parentId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Folder_parentId_idx" ON public."Folder" USING btree ("parentId");


--
-- Name: Folder_teamId_path_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Folder_teamId_path_key" ON public."Folder" USING btree ("teamId", path);


--
-- Name: IncomingWebhook_externalId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "IncomingWebhook_externalId_key" ON public."IncomingWebhook" USING btree ("externalId");


--
-- Name: IncomingWebhook_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "IncomingWebhook_teamId_idx" ON public."IncomingWebhook" USING btree ("teamId");


--
-- Name: Invitation_email_teamId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Invitation_email_teamId_key" ON public."Invitation" USING btree (email, "teamId");


--
-- Name: Invitation_token_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Invitation_token_key" ON public."Invitation" USING btree (token);


--
-- Name: LinkPreset_pId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "LinkPreset_pId_key" ON public."LinkPreset" USING btree ("pId");


--
-- Name: LinkPreset_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "LinkPreset_teamId_idx" ON public."LinkPreset" USING btree ("teamId");


--
-- Name: Link_documentId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Link_documentId_idx" ON public."Link" USING btree ("documentId");


--
-- Name: Link_domainSlug_slug_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Link_domainSlug_slug_key" ON public."Link" USING btree ("domainSlug", slug);


--
-- Name: Link_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Link_teamId_idx" ON public."Link" USING btree ("teamId");


--
-- Name: Link_url_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Link_url_key" ON public."Link" USING btree (url);


--
-- Name: Message_conversationId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Message_conversationId_idx" ON public."Message" USING btree ("conversationId");


--
-- Name: Message_userId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Message_userId_idx" ON public."Message" USING btree ("userId");


--
-- Name: Message_viewId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Message_viewId_idx" ON public."Message" USING btree ("viewId");


--
-- Name: Message_viewerId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Message_viewerId_idx" ON public."Message" USING btree ("viewerId");


--
-- Name: Reaction_viewId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Reaction_viewId_idx" ON public."Reaction" USING btree ("viewId");


--
-- Name: RestrictedToken_hashedKey_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "RestrictedToken_hashedKey_key" ON public."RestrictedToken" USING btree ("hashedKey");


--
-- Name: RestrictedToken_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "RestrictedToken_teamId_idx" ON public."RestrictedToken" USING btree ("teamId");


--
-- Name: RestrictedToken_userId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "RestrictedToken_userId_idx" ON public."RestrictedToken" USING btree ("userId");


--
-- Name: SentEmail_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "SentEmail_teamId_idx" ON public."SentEmail" USING btree ("teamId");


--
-- Name: Session_sessionToken_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Session_sessionToken_key" ON public."Session" USING btree ("sessionToken");


--
-- Name: TagItem_tagId_dataroomId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "TagItem_tagId_dataroomId_idx" ON public."TagItem" USING btree ("tagId", "dataroomId");


--
-- Name: TagItem_tagId_documentId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "TagItem_tagId_documentId_idx" ON public."TagItem" USING btree ("tagId", "documentId");


--
-- Name: TagItem_tagId_linkId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "TagItem_tagId_linkId_idx" ON public."TagItem" USING btree ("tagId", "linkId");


--
-- Name: Tag_id_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Tag_id_idx" ON public."Tag" USING btree (id);


--
-- Name: Tag_name_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Tag_name_idx" ON public."Tag" USING btree (name);


--
-- Name: Tag_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Tag_teamId_idx" ON public."Tag" USING btree ("teamId");


--
-- Name: Tag_teamId_name_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Tag_teamId_name_key" ON public."Tag" USING btree ("teamId", name);


--
-- Name: Team_stripeId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Team_stripeId_key" ON public."Team" USING btree ("stripeId");


--
-- Name: Team_subscriptionId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Team_subscriptionId_key" ON public."Team" USING btree ("subscriptionId");


--
-- Name: UserTeam_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "UserTeam_teamId_idx" ON public."UserTeam" USING btree ("teamId");


--
-- Name: UserTeam_userId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "UserTeam_userId_idx" ON public."UserTeam" USING btree ("userId");


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: User_stripeId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "User_stripeId_key" ON public."User" USING btree ("stripeId");


--
-- Name: User_subscriptionId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "User_subscriptionId_key" ON public."User" USING btree ("subscriptionId");


--
-- Name: VerificationToken_identifier_token_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "VerificationToken_identifier_token_key" ON public."VerificationToken" USING btree (identifier, token);


--
-- Name: VerificationToken_token_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "VerificationToken_token_key" ON public."VerificationToken" USING btree (token);


--
-- Name: View_dataroomId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "View_dataroomId_idx" ON public."View" USING btree ("dataroomId");


--
-- Name: View_dataroomViewId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "View_dataroomViewId_idx" ON public."View" USING btree ("dataroomViewId");


--
-- Name: View_documentId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "View_documentId_idx" ON public."View" USING btree ("documentId");


--
-- Name: View_linkId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "View_linkId_idx" ON public."View" USING btree ("linkId");


--
-- Name: View_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "View_teamId_idx" ON public."View" USING btree ("teamId");


--
-- Name: ViewerGroupAccessControls_groupId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "ViewerGroupAccessControls_groupId_idx" ON public."ViewerGroupAccessControls" USING btree ("groupId");


--
-- Name: ViewerGroupAccessControls_groupId_itemId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "ViewerGroupAccessControls_groupId_itemId_key" ON public."ViewerGroupAccessControls" USING btree ("groupId", "itemId");


--
-- Name: ViewerGroupMembership_groupId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "ViewerGroupMembership_groupId_idx" ON public."ViewerGroupMembership" USING btree ("groupId");


--
-- Name: ViewerGroupMembership_viewerId_groupId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "ViewerGroupMembership_viewerId_groupId_key" ON public."ViewerGroupMembership" USING btree ("viewerId", "groupId");


--
-- Name: ViewerGroupMembership_viewerId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "ViewerGroupMembership_viewerId_idx" ON public."ViewerGroupMembership" USING btree ("viewerId");


--
-- Name: ViewerGroup_dataroomId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "ViewerGroup_dataroomId_idx" ON public."ViewerGroup" USING btree ("dataroomId");


--
-- Name: ViewerGroup_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "ViewerGroup_teamId_idx" ON public."ViewerGroup" USING btree ("teamId");


--
-- Name: Viewer_dataroomId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Viewer_dataroomId_idx" ON public."Viewer" USING btree ("dataroomId");


--
-- Name: Viewer_teamId_email_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Viewer_teamId_email_key" ON public."Viewer" USING btree ("teamId", email);


--
-- Name: Viewer_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Viewer_teamId_idx" ON public."Viewer" USING btree ("teamId");


--
-- Name: Webhook_pId_key; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE UNIQUE INDEX "Webhook_pId_key" ON public."Webhook" USING btree ("pId");


--
-- Name: Webhook_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "Webhook_teamId_idx" ON public."Webhook" USING btree ("teamId");


--
-- Name: YearInReview_status_attempts_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "YearInReview_status_attempts_idx" ON public."YearInReview" USING btree (status, attempts);


--
-- Name: YearInReview_teamId_idx; Type: INDEX; Schema: public; Owner: shimmer_owner
--

CREATE INDEX "YearInReview_teamId_idx" ON public."YearInReview" USING btree ("teamId");


--
-- Name: Account Account_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: AgreementResponse AgreementResponse_agreementId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."AgreementResponse"
    ADD CONSTRAINT "AgreementResponse_agreementId_fkey" FOREIGN KEY ("agreementId") REFERENCES public."Agreement"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: AgreementResponse AgreementResponse_viewId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."AgreementResponse"
    ADD CONSTRAINT "AgreementResponse_viewId_fkey" FOREIGN KEY ("viewId") REFERENCES public."View"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Agreement Agreement_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Agreement"
    ADD CONSTRAINT "Agreement_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Brand Brand_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Brand"
    ADD CONSTRAINT "Brand_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Chat Chat_documentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Chat"
    ADD CONSTRAINT "Chat_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES public."Document"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Chat Chat_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Chat"
    ADD CONSTRAINT "Chat_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ConversationParticipant ConversationParticipant_conversationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."ConversationParticipant"
    ADD CONSTRAINT "ConversationParticipant_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES public."Conversation"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ConversationParticipant ConversationParticipant_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."ConversationParticipant"
    ADD CONSTRAINT "ConversationParticipant_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ConversationParticipant ConversationParticipant_viewerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."ConversationParticipant"
    ADD CONSTRAINT "ConversationParticipant_viewerId_fkey" FOREIGN KEY ("viewerId") REFERENCES public."Viewer"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ConversationView ConversationView_conversationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."ConversationView"
    ADD CONSTRAINT "ConversationView_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES public."Conversation"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ConversationView ConversationView_viewId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."ConversationView"
    ADD CONSTRAINT "ConversationView_viewId_fkey" FOREIGN KEY ("viewId") REFERENCES public."View"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Conversation Conversation_dataroomDocumentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Conversation"
    ADD CONSTRAINT "Conversation_dataroomDocumentId_fkey" FOREIGN KEY ("dataroomDocumentId") REFERENCES public."DataroomDocument"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Conversation Conversation_dataroomId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Conversation"
    ADD CONSTRAINT "Conversation_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES public."Dataroom"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Conversation Conversation_initialViewId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Conversation"
    ADD CONSTRAINT "Conversation_initialViewId_fkey" FOREIGN KEY ("initialViewId") REFERENCES public."View"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Conversation Conversation_linkId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Conversation"
    ADD CONSTRAINT "Conversation_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES public."Link"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Conversation Conversation_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Conversation"
    ADD CONSTRAINT "Conversation_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Conversation Conversation_viewerGroupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Conversation"
    ADD CONSTRAINT "Conversation_viewerGroupId_fkey" FOREIGN KEY ("viewerGroupId") REFERENCES public."ViewerGroup"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: CustomFieldResponse CustomFieldResponse_viewId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."CustomFieldResponse"
    ADD CONSTRAINT "CustomFieldResponse_viewId_fkey" FOREIGN KEY ("viewId") REFERENCES public."View"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: CustomField CustomField_linkId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."CustomField"
    ADD CONSTRAINT "CustomField_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES public."Link"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DataroomBrand DataroomBrand_dataroomId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DataroomBrand"
    ADD CONSTRAINT "DataroomBrand_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES public."Dataroom"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DataroomDocument DataroomDocument_dataroomId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DataroomDocument"
    ADD CONSTRAINT "DataroomDocument_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES public."Dataroom"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DataroomDocument DataroomDocument_documentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DataroomDocument"
    ADD CONSTRAINT "DataroomDocument_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES public."Document"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DataroomDocument DataroomDocument_folderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DataroomDocument"
    ADD CONSTRAINT "DataroomDocument_folderId_fkey" FOREIGN KEY ("folderId") REFERENCES public."DataroomFolder"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: DataroomFolder DataroomFolder_dataroomId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DataroomFolder"
    ADD CONSTRAINT "DataroomFolder_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES public."Dataroom"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DataroomFolder DataroomFolder_parentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DataroomFolder"
    ADD CONSTRAINT "DataroomFolder_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public."DataroomFolder"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Dataroom Dataroom_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Dataroom"
    ADD CONSTRAINT "Dataroom_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DocumentPage DocumentPage_versionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DocumentPage"
    ADD CONSTRAINT "DocumentPage_versionId_fkey" FOREIGN KEY ("versionId") REFERENCES public."DocumentVersion"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DocumentUpload DocumentUpload_dataroomDocumentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DocumentUpload"
    ADD CONSTRAINT "DocumentUpload_dataroomDocumentId_fkey" FOREIGN KEY ("dataroomDocumentId") REFERENCES public."DataroomDocument"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: DocumentUpload DocumentUpload_dataroomId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DocumentUpload"
    ADD CONSTRAINT "DocumentUpload_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES public."Dataroom"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: DocumentUpload DocumentUpload_documentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DocumentUpload"
    ADD CONSTRAINT "DocumentUpload_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES public."Document"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DocumentUpload DocumentUpload_linkId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DocumentUpload"
    ADD CONSTRAINT "DocumentUpload_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES public."Link"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DocumentUpload DocumentUpload_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DocumentUpload"
    ADD CONSTRAINT "DocumentUpload_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DocumentUpload DocumentUpload_viewId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DocumentUpload"
    ADD CONSTRAINT "DocumentUpload_viewId_fkey" FOREIGN KEY ("viewId") REFERENCES public."View"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: DocumentUpload DocumentUpload_viewerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DocumentUpload"
    ADD CONSTRAINT "DocumentUpload_viewerId_fkey" FOREIGN KEY ("viewerId") REFERENCES public."Viewer"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: DocumentVersion DocumentVersion_documentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."DocumentVersion"
    ADD CONSTRAINT "DocumentVersion_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES public."Document"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Document Document_folderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Document"
    ADD CONSTRAINT "Document_folderId_fkey" FOREIGN KEY ("folderId") REFERENCES public."Folder"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Document Document_ownerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Document"
    ADD CONSTRAINT "Document_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Document Document_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Document"
    ADD CONSTRAINT "Document_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Domain Domain_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Domain"
    ADD CONSTRAINT "Domain_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Domain Domain_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Domain"
    ADD CONSTRAINT "Domain_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: FeedbackResponse FeedbackResponse_feedbackId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."FeedbackResponse"
    ADD CONSTRAINT "FeedbackResponse_feedbackId_fkey" FOREIGN KEY ("feedbackId") REFERENCES public."Feedback"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: FeedbackResponse FeedbackResponse_viewId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."FeedbackResponse"
    ADD CONSTRAINT "FeedbackResponse_viewId_fkey" FOREIGN KEY ("viewId") REFERENCES public."View"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Feedback Feedback_linkId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Feedback"
    ADD CONSTRAINT "Feedback_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES public."Link"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Folder Folder_parentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Folder"
    ADD CONSTRAINT "Folder_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public."Folder"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Folder Folder_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Folder"
    ADD CONSTRAINT "Folder_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: IncomingWebhook IncomingWebhook_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."IncomingWebhook"
    ADD CONSTRAINT "IncomingWebhook_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Invitation Invitation_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Invitation"
    ADD CONSTRAINT "Invitation_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: LinkPreset LinkPreset_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."LinkPreset"
    ADD CONSTRAINT "LinkPreset_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Link Link_agreementId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Link"
    ADD CONSTRAINT "Link_agreementId_fkey" FOREIGN KEY ("agreementId") REFERENCES public."Agreement"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Link Link_dataroomId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Link"
    ADD CONSTRAINT "Link_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES public."Dataroom"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Link Link_documentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Link"
    ADD CONSTRAINT "Link_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES public."Document"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Link Link_domainId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Link"
    ADD CONSTRAINT "Link_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES public."Domain"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Link Link_groupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Link"
    ADD CONSTRAINT "Link_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES public."ViewerGroup"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Link Link_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Link"
    ADD CONSTRAINT "Link_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message Message_conversationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES public."Conversation"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message Message_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Message Message_viewId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_viewId_fkey" FOREIGN KEY ("viewId") REFERENCES public."View"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Message Message_viewerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_viewerId_fkey" FOREIGN KEY ("viewerId") REFERENCES public."Viewer"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Reaction Reaction_viewId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Reaction"
    ADD CONSTRAINT "Reaction_viewId_fkey" FOREIGN KEY ("viewId") REFERENCES public."View"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: RestrictedToken RestrictedToken_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."RestrictedToken"
    ADD CONSTRAINT "RestrictedToken_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: RestrictedToken RestrictedToken_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."RestrictedToken"
    ADD CONSTRAINT "RestrictedToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SentEmail SentEmail_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."SentEmail"
    ADD CONSTRAINT "SentEmail_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Session Session_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Session"
    ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TagItem TagItem_dataroomId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."TagItem"
    ADD CONSTRAINT "TagItem_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES public."Dataroom"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TagItem TagItem_documentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."TagItem"
    ADD CONSTRAINT "TagItem_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES public."Document"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TagItem TagItem_linkId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."TagItem"
    ADD CONSTRAINT "TagItem_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES public."Link"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: TagItem TagItem_tagId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."TagItem"
    ADD CONSTRAINT "TagItem_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES public."Tag"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Tag Tag_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Tag"
    ADD CONSTRAINT "Tag_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserTeam UserTeam_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."UserTeam"
    ADD CONSTRAINT "UserTeam_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: UserTeam UserTeam_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."UserTeam"
    ADD CONSTRAINT "UserTeam_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: View View_dataroomId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."View"
    ADD CONSTRAINT "View_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES public."Dataroom"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: View View_documentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."View"
    ADD CONSTRAINT "View_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES public."Document"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: View View_groupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."View"
    ADD CONSTRAINT "View_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES public."ViewerGroup"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: View View_linkId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."View"
    ADD CONSTRAINT "View_linkId_fkey" FOREIGN KEY ("linkId") REFERENCES public."Link"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: View View_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."View"
    ADD CONSTRAINT "View_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: View View_viewerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."View"
    ADD CONSTRAINT "View_viewerId_fkey" FOREIGN KEY ("viewerId") REFERENCES public."Viewer"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ViewerGroupAccessControls ViewerGroupAccessControls_groupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."ViewerGroupAccessControls"
    ADD CONSTRAINT "ViewerGroupAccessControls_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES public."ViewerGroup"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ViewerGroupMembership ViewerGroupMembership_groupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."ViewerGroupMembership"
    ADD CONSTRAINT "ViewerGroupMembership_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES public."ViewerGroup"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ViewerGroupMembership ViewerGroupMembership_viewerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."ViewerGroupMembership"
    ADD CONSTRAINT "ViewerGroupMembership_viewerId_fkey" FOREIGN KEY ("viewerId") REFERENCES public."Viewer"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ViewerGroup ViewerGroup_dataroomId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."ViewerGroup"
    ADD CONSTRAINT "ViewerGroup_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES public."Dataroom"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ViewerGroup ViewerGroup_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."ViewerGroup"
    ADD CONSTRAINT "ViewerGroup_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Viewer Viewer_dataroomId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Viewer"
    ADD CONSTRAINT "Viewer_dataroomId_fkey" FOREIGN KEY ("dataroomId") REFERENCES public."Dataroom"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Viewer Viewer_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Viewer"
    ADD CONSTRAINT "Viewer_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Webhook Webhook_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shimmer_owner
--

ALTER TABLE ONLY public."Webhook"
    ADD CONSTRAINT "Webhook_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Team"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO neon_superuser WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON TABLES TO neon_superuser WITH GRANT OPTION;


--
-- PostgreSQL database dump complete
--

