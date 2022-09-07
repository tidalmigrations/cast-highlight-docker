#!/bin/bash

if [[ "$1" != "cast" ]]; then
	exec "$@"
fi

die() {
	printf '%s\n' "$1" >&2
	exit 1
}

flags=()
sourceDir=
workingDir=
login=
password=

shift # Remove "cast" from arguments

while :; do
	case $1 in
		--help|--printTechnos)
			flags=("$1")
			break
			;;

		--sourceDir) # Takes an option argument; ensure it has been specified.
			if [[ -n "$2" ]]; then
				sourceDir=$2
				flags+=("$1" "$2")
				shift
			else
				die 'ERROR: "--sourceDir" requires a non-empty option argument.'
			fi
			;;
		--sourceDir=?*)
			sourceDir=${1#*=} # Delete everything up to "=" and assign the remainder.
			flags+=(--sourceDir "${sourceDir}")
			;;
		--sourceDir=) # Handle the case of empty --sourceDir=
			die 'ERROR: "--sourceDir" requires a non-empty option argument.'
			;;

		--workingDir)
			if [[ -n "$2" ]]; then
				workingDir=$2
				flags+=("$1" "$2")
				shift
			else
				die 'ERROR: "--workingDir" requires a non-empty option argument.'
			fi
			;;
		--workingDir=?*)
			workingDir=${1#*=}
			flags+=(--workingDir "${workingDir}")
			;;
		--workingDir=)
			die 'ERROR: "--workingDir" requires a non-empty option argument.'
			;;

		--technologies)
			if [[ -n "$2" ]]; then
				flags+=("$1" "$2")
				shift
			else
				die 'ERROR: "--technologies" requires a non-empty option argument.'
			fi
			;;
		--technologies=?*)
			technologies=${1#*=}
			flags+=(--technologies "${technologies}")
			;;
		--technologies=)
			die 'ERROR: "--technologies" requires a non-empty option argument.'
			;;

		--ignoreDirectories)
			if [[ -n "$2" ]]; then
				flags+=("$1" "$2")
				shift
			else
				die 'ERROR: "--ignoreDirectories" requires a non-empty option argument.'
			fi
			;;
		--ignoreDirectories=?*)
			ignoreDirectories=${1#*=}
			flags+=(--ignoreDirectories "${ignoreDirectories}")
			;;
		--ignoreDirectories=)
			die 'ERROR: "--ignoreDirectories" requires a non-empty option argument.'
			;;

		--analyzeDir)
			if [[ -n "$2" ]]; then
				flags+=("$1" "$2")
				shift
			else
				die 'ERROR: "--analyzeDir" requires a non-empty option argument.'
			fi
			;;
		--analyzeDir=?*)
			analyzeDir=${1#*=}
			flags+=(--analyzeDir "${analyzeDir}")
			;;
		--analyzeDir=)
			die 'ERROR: "--analyzeDir" requires a non-empty option argument.'
			;;

		--perlInstallDir)
			if [[ -n "$2" ]]; then
				flags+=("$1" "$2")
				shift
			else
				die 'ERROR: "--perlInstallDir" requires a non-empty option argument.'
			fi
			;;
		--perlInstallDir=?*)
			perlInstallDir=${1#*=}
			flags+=(--perlInstallDir "${perlInstallDir}")
			;;
		--perlInstallDir=)
			die 'ERROR: "--perlInstallDir" requires a non-empty option argument.'
			;;

		--keywordScan)
			if [[ -n "$2" ]]; then
				flags+=("$1" "$2")
				shift
			else
				die 'ERROR: "--keywordScan" requires a non-empty option argument.'
			fi
			;;
		--keywordScan=?*)
			keywordScan=${1#*=}
			flags+=(--keywordScan "${keywordScan}")
			;;
		--keywordScan=)
			die 'ERROR: "--keywordScan" requires a non-empty option argument.'
			;;

		--skipUpload)
			flags+=("$1")
			;;

		--login)
			if [[ -n "$2" ]]; then
				login=$2
				flags+=("$1" "$2")
				shift
			else
				die 'ERROR: "--login" requires a non-empty option argument.'
			fi
			;;
		--login=?*)
			login=${1#*=}
			flags+=(--login "${login}")
			;;
		--login=)
			die 'ERROR: "--login" requires a non-empty option argument.'
			;;

		--password)
			if [[ -n "$2" ]]; then
				password=$2
				flags+=("$1" "$2")
				shift
			else
				die 'ERROR: "--password" requires a non-empty option argument.'
			fi
			;;
		--password=?*)
			password=${1#*=}
			flags+=(--password "${password}")
			;;
		--password=)
			die 'ERROR: "--password" requires a non-empty option argument.'
			;;

		--companyId)
			if [[ -n "$2" ]]; then
				companyId=$2
				flags+=("$1" "$2")
				shift
			else
				die 'ERROR: "--companyId" requires a non-empty option argument.'
			fi
			;;
		--companyId=?*)
			companyId=${1#*=}
			flags+=(--companyId "${companyId}")
			;;
		--companyId=)
			die 'ERROR: "--companyId" requires a non-empty option argument.'
			;;

		--applicationId)
			if [[ -n "$2" ]]; then
				flags+=("$1" "$2")
				shift
			else
				die 'ERROR: "--applicationId" requires a non-empty option argument.'
			fi
			;;
		--applicationId=?*)
			applicationId=${1#*=}
			flags+=(--applicationId "${applicationId}")
			;;
		--applicationId=)
			die 'ERROR: "--applicationId" requires a non-empty option argument.'
			;;

		--serverUrl)
			if [[ -n "$2" ]]; then
				flags+=("$1" "$2")
				shift
			else
				die 'ERROR: "--serverUrl" requires a non-empty option argument.'
			fi
			;;
		--serverUrl=?*)
			serverUrl=${1#*=}
			flags+=(--serverUrl "${serverUrl}")
			;;
		--serverUrl=)
			die 'ERROR: "--serverUrl" requires a non-empty option argument.'
			;;

		--snapshotDatetime)
			if [[ -n "$2" ]]; then
				flags+=("$1" "$2")
				shift
			else
				die 'ERROR: "--snapshotDatetime" requires a non-empty option argument.'
			fi
			;;
		--snapshotDatetime=?*)
			snapshotDatetime=${1#*=}
			flags+=(--snapshotDatetime "${snapshotDatetime}")
			;;
		--snapshotDatetime=)
			die 'ERROR: "--snapshotDatetime" requires a non-empty option argument.'
			;;

		--snapshotLabel)
			if [[ -n "$2" ]]; then
				flags+=("$1" "$2")
				shift
			else
				die 'ERROR: "--snapshotLabel" requires a non-empty option argument.'
			fi
			;;
		--snapshotLabel=?*)
			snapshotLabel=${1#*=}
			flags+=(--snapshotLabel "${snapshotLabel}")
			;;
		--snapshotLabel=)
			die 'ERROR: "--snapshotLabel" requires a non-empty option argument.'
			;;

		--) # End of all options.
			shift
			break
			;;
		-?*)
			printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
			;;
		*) # Default case: No more options, so break out of the loop.
			break
	esac

	shift
done

if [[ -z "${workingDir}" ]]; then
	workingDir="/tmp"
	flags+=(--workingDir "${workingDir}")
fi

secrets=/secrets/.env
if [[ -z "${login}" ]] || [[ -z "${password}" ]]; then
	if [[ -s "${secrets}" ]]; then
		# shellcheck source=/dev/null
		source "${secrets}"
		rm -f "${secrets}"
	fi

	if [[ -n "${CAST_LOGIN:-}" ]]; then
		flags+=(--login "${CAST_LOGIN}")
	fi

	if [[ -n "${CAST_PASSWORD:-}" ]]; then
		flags+=(--password "${CAST_PASSWORD}")
	fi

	if [[ -n "${BASIC_AUTH:-}" ]]; then
		flags+=(--basicAuth "${BASIC_AUTH}")
	fi
fi

exec java -jar HighlightAutomation.jar "${flags[@]}"
