DROP TYPE IF EXISTS formation_level cascade ;
DROP TYPE IF EXISTS location_type cascade ;
CREATE TYPE formation_level AS ENUM ('BEGINER','INTERMEDIARY','ADVANCED','EXPERT');
CREATE TYPE location_type AS ENUM ('ONLINE','INTRA','FACE_TO_FACE');


DROP TABLE IF EXISTS files cascade;
CREATE TABLE files (
                       id integer NOT NULL,
                       path varchar(255) NOT NULL,
                       content bytea,
                       name varchar(255) NOT NULL,
                       description text,
                       PRIMARY KEY (id)
);


DROP TABLE IF EXISTS certifications cascade;
CREATE TABLE certifications (
                                id integer NOT NULL,
                                path varchar(255) NOT NULL,
                                content bytea,
                                name varchar(255) NOT NULL,
                                description text,
                                PRIMARY KEY (id)
);


DROP TABLE IF EXISTS trainings cascade;
CREATE TABLE trainings (
                           id integer NOT NULL,
                           name varchar(255) NOT NULL,
                           slug varchar(255) NOT NULL,
                           description text,
                           short_description integer DEFAULT NULL,
                           hours integer DEFAULT NULL,
                           level formation_level NOT NULL,
                           cpf_eligible boolean DEFAULT false,
                           location location_type NOT NULL,
                           price_ht integer NOT NULL,
                           teachers_description text,
                           evaluation text,
                           quality text,
                           accessibility text,
                           student_profile text,
                           requirements text,
                           content text,
                           resources text,
                           objectifs text,
                           address_id integer,
                           agency_id integer,
                           file_id integer,
                           image_id integer,
                           certification_id integer,
                           PRIMARY KEY (id),
                           UNIQUE(slug),
                           UNIQUE (file_id),
                           UNIQUE (certification_id),
                           UNIQUE (image_id),
                           CONSTRAINT training_file_fk FOREIGN KEY (file_id) REFERENCES files(id),
                           CONSTRAINT training_image_fk FOREIGN KEY (image_id) REFERENCES files(id),
                           CONSTRAINT training_address_fk FOREIGN KEY (address_id) REFERENCES address(id),
                           CONSTRAINT training_agencies_fk FOREIGN KEY (agency_id) REFERENCES agencies(id),
                           CONSTRAINT training_certification_fk FOREIGN KEY (certification_id) REFERENCES certifications(id)
);


DROP TABLE IF EXISTS trainings_items;
CREATE TABLE trainings_items (
                                 training_id integer NOT NULL,
                                 item_id integer NOT NULL,
                                 PRIMARY KEY(training_id, item_id),
                                 CONSTRAINT trainings_items_training_fk FOREIGN KEY (training_id) REFERENCES trainings(id),
                                 CONSTRAINT trainings_items_item_fk FOREIGN KEY (item_id) REFERENCES files(id)
);

DROP TABLE IF EXISTS trainings_objectives;
CREATE TABLE trainings_objectives (
                                      training_id integer NOT NULL,
                                      objective_id integer NOT NULL,
                                      PRIMARY KEY(training_id, objective_id),
                                      CONSTRAINT trainings_objectives_training_fk FOREIGN KEY (training_id) REFERENCES trainings(id),
                                      CONSTRAINT trainings_objectives_objective_fk FOREIGN KEY (objective_id) REFERENCES files(id)
);


DROP TABLE IF EXISTS trainings_resources;
CREATE TABLE trainings_resources (
                                     training_id integer NOT NULL,
                                     resource_id integer NOT NULL,
                                     PRIMARY KEY (training_id, resource_id),
                                     CONSTRAINT trainings_resources_training_fk FOREIGN KEY (training_id) REFERENCES trainings(id),
                                     CONSTRAINT trainings_resources_resource_fk FOREIGN KEY (resource_id) REFERENCES files(id)
);

DROP TABLE IF EXISTS sessions cascade;
CREATE TABLE sessions (
                          id integer NOT NULL,
                          name varchar(255) NOT NULL,
                          description text,
                          start_date date NOT NULL,
                          end_date date NOT NULL,
                          PRIMARY KEY (id)
);

DROP TABLE IF EXISTS categories CASCADE;
CREATE TABLE categories (
                            id integer NOT NULL,
                            slug varchar(255) NOT NULL,
                            name varchar(255) NOT NULL,
                            description text,
                            short_description text,
                            image_id integer,
                            PRIMARY KEY (id),
                            UNIQUE(slug),
                            UNIQUE (image_id),
                            CONSTRAINT category_image_fk FOREIGN KEY (image_id) REFERENCES files(id)
);


DROP TABLE IF EXISTS sub_categories CASCADE;
CREATE TABLE sub_categories (
                                id integer NOT NULL,
                                categorie_id integer,
                                slug varchar(255) NOT NULL,
                                name varchar(255) NOT NULL,
                                description text,
                                short_description text,
                                image varchar(255) NOT NULL,
                                PRIMARY KEY (id),
                                UNIQUE(slug),
                                CONSTRAINT categories_fk FOREIGN KEY (categorie_id) REFERENCES categories (id)

);


DROP TABLE IF EXISTS address cascade;
CREATE TABLE address (
                         id integer NOT NULL,
                         street varchar(255) NOT NULL,
                         city varchar(255) NOT NULL,
                         zip varchar(5) NOT NULL,
                         country varchar(255) NOT NULL,
                         PRIMARY KEY (id)
);


DROP TABLE IF EXISTS compagnies cascade;
CREATE TABLE compagnies (
                            id integer NOT NULL,
                            siret varchar(14) DEFAULT NULL,
                            name varchar(255) NOT NULL,
                            description varchar(255) DEFAULT NULL,
                            email varchar(255) NOT NULL,
                            telephone varchar(10) NOT NULL,
                            address_id integer NOT NULL,
                            PRIMARY KEY (id),
                            CONSTRAINT agencies_address_fk FOREIGN KEY (address_id) REFERENCES address(id)
);


DROP TABLE IF EXISTS agencies cascade;
CREATE TABLE agencies (
                          id integer NOT NULL,
                          siret varchar(14) DEFAULT NULL,
                          name varchar(255) NOT NULL,
                          description varchar(255) DEFAULT NULL,
                          email varchar(255) NOT NULL,
                          telephone varchar(10) NOT NULL,
                          address_id integer NOT NULL,
                          compagny_id integer NOT NULL,
                          PRIMARY KEY (id),
                          CONSTRAINT agencies_compagny_fk FOREIGN KEY (compagny_id) REFERENCES compagnies(id),
                          CONSTRAINT agencies_address_fk FOREIGN KEY (address_id) REFERENCES address(id)
);

DROP TABLE IF EXISTS compagnies_certifications;
CREATE TABLE compagnies_certifications (
                                           compagny_id integer NOT NULL,
                                           certification_id integer NOT NULL,
                                           PRIMARY KEY (compagny_id, certification_id),
                                           CONSTRAINT compagnies_certifications_compagny_fk FOREIGN KEY (compagny_id) REFERENCES compagnies(id),
                                           CONSTRAINT compagnies_certifications_agency_fk FOREIGN KEY (certification_id) REFERENCES certifications(id)
);

DROP TABLE IF EXISTS trainings_agencies;
CREATE TABLE trainings_agencies (
                                    training_id integer NOT NULL,
                                    agency_id integer NOT NULL,
                                    PRIMARY KEY (training_id, agency_id),
                                    CONSTRAINT trainings_agencies_training_fk FOREIGN KEY (training_id) REFERENCES trainings(id),
                                    CONSTRAINT trainings_agencies_agency_fk FOREIGN KEY (agency_id) REFERENCES agencies(id)
);

DROP TABLE IF EXISTS addresss_agencies;
CREATE TABLE addresss_agencies (
                                   address_id integer NOT NULL,
                                   agency_id integer NOT NULL,
                                   PRIMARY KEY (address_id, agency_id),
                                   CONSTRAINT addresss_agencies_address_fk FOREIGN KEY (address_id) REFERENCES address(id),
                                   CONSTRAINT trainings_agencies_agency_fk FOREIGN KEY (agency_id) REFERENCES agencies(id)
);

DROP TABLE IF EXISTS candidates cascade;
CREATE TABLE candidates (
                            id integer NOT NULL,
                            siret varchar(14) DEFAULT NULL,
                            address_id integer NOT NULL,
                            first_name varchar(255) NOT NULL,
                            last_name varchar(255) DEFAULT NULL,
                            email varchar(255) NOT NULL,
                            telephone varchar(10) NOT NULL,
                            PRIMARY KEY (id),
                            CONSTRAINT candidates_address_fk FOREIGN KEY (address_id) REFERENCES address(id)
);


DROP TABLE IF EXISTS trainings_sessions;
CREATE TABLE trainings_sessions (
                                    training_id integer NOT NULL,
                                    session_id integer NOT NULL,
                                    PRIMARY KEY (training_id,session_id),

                                    CONSTRAINT trainings_sessions_ibfk_1 FOREIGN KEY (training_id) REFERENCES trainings (id),
                                    CONSTRAINT trainings_sessions_ibfk_2 FOREIGN KEY (session_id) REFERENCES sessions (id)
);


DROP TABLE IF EXISTS categories_trainings;
CREATE TABLE categories_trainings (
                                      category_id integer NOT NULL,
                                      training_id integer NOT NULL,
                                      PRIMARY KEY(category_id,training_id),

                                      CONSTRAINT categories_trainings_ibfk_1 FOREIGN KEY (category_id) REFERENCES categories (id),
                                      CONSTRAINT categories_trainings_ibfk_2 FOREIGN KEY (training_id) REFERENCES trainings (id)
);


DROP TABLE IF EXISTS sub_categories_trainings;
CREATE TABLE sub_categories_trainings (
                                          sub_category_id integer NOT NULL,
                                          training_id integer NOT NULL,
                                          PRIMARY KEY (sub_category_id, training_id),

                                          CONSTRAINT sub_categories_trainings_ibfk_1 FOREIGN KEY (sub_category_id) REFERENCES sub_categories (id),
                                          CONSTRAINT sub_categories_trainings_ibfk_2 FOREIGN KEY (training_id) REFERENCES trainings (id)
);


DROP TABLE IF EXISTS seesions_candidates;
CREATE TABLE seesions_candidates (
                                     session_id integer NOT NULL,
                                     candidate_id integer NOT NULL,
                                     PRIMARY KEY (session_id, candidate_id),
                                     CONSTRAINT candidates_sessions_session_fk FOREIGN KEY (session_id) REFERENCES sessions(id),
                                     CONSTRAINT candidates_sessions_candidate_fk FOREIGN KEY (candidate_id) REFERENCES candidates(id)
);


DROP TABLE IF EXISTS seesions_candidates_trainings;

DROP TABLE IF EXISTS training_metas;
CREATE TABLE training_metas (
                                id integer NOT NULL,
                                training_id integer NOT NULL,
                                key integer NOT NULL,
                                value text NOT NULL,
                                PRIMARY KEY (id),
                                UNIQUE (training_id),
                                CONSTRAINT training_metas_ibfk_1 FOREIGN KEY (training_id) REFERENCES trainings (id)
);
