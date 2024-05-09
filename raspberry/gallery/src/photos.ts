import { readdir } from "node:fs/promises";
import path from 'node:path';

export interface PhotoConfig {
    fileName: string,
    createDate: string,
    createSecondsEpoc: number,
    trigger: "Time" | "External" | "Trigger",
    subjectDistance: number,
    exposureTime: string,
    ISO: number
}


function parsePhotoConfig(contents: any): PhotoConfig | null {
    try {
        const requiredFields = [
            "File Name",
            "Create Date",
            "Create Seconds Epoch",
            "Trigger",
            "Subject Distance",
            "Exposure Time",
            "ISO",
        ];

        for (const field of requiredFields) {
            if (!contents[field]) {
                return null; // return null if any of the required fields are missing
            }
        }

        const photoConfig: PhotoConfig = {
            fileName: contents["File Name"],
            createDate: contents["Create Date"],
            createSecondsEpoc: contents["Create Seconds Epoch"],
            trigger: contents["Trigger"],
            subjectDistance: contents["Subject Distance"],
            exposureTime: contents["Exposure Time"],
            ISO: contents["ISO"],
        };

        return photoConfig;
    } catch (error) {
        console.error(`Error parsing photo config: ${error}`);
        return null;
    }
}

export const groupPhotoConfigsByDate = (photoConfigs: (PhotoConfig | null)[]) => {

    return photoConfigs.reduce((groups, config) => {
        if (config == null) {
            return groups
        }
        const [date] = config.createDate.split(" ");
        if (!groups[date]) {
            groups[date] = [];
        }
        groups[date].push(config);
        return groups;
    }, {} as Record<string, PhotoConfig[]>);
};


async function readPhotoConfig(filePath: string) {
    const file = Bun.file(filePath);
    const contents = await file.json();
    const photoConfig = parsePhotoConfig(contents)
    return photoConfig

}

export async function readPhotosFromPublicDirectory(directory: string) {

    const files = await readdir(directory, { recursive: true });

    let photoConfigs = await Promise.all(
        files
            .filter(filePath => filePath.endsWith('.json'))
            .map(filepath => path.join(directory, filepath))
            .map(filePath => readPhotoConfig(filePath))
    );

    photoConfigs = photoConfigs.filter(config => config != null)


    return photoConfigs;
}

