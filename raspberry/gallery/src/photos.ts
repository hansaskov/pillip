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

function parsePhotoConfig(contents: any) {

    const photoConfig: PhotoConfig = {
        fileName: contents["File Name"],
        createDate: contents["Create Date"],
        createSecondsEpoc: contents["Create Seconds Epoch"],
        trigger: contents["Trigger"],
        subjectDistance: contents["Subject Distance"],
        exposureTime: contents["Exposure Time"],
        ISO: contents["ISO"],
      };

    return photoConfig
} 

export const groupPhotoConfigsByDate = (photoConfigs: PhotoConfig[]) => {
    return photoConfigs.reduce((groups, config) => {
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
    photoConfig.fileName = filePath.replace(".json", ".jpg")
    return photoConfig

}

export async function readPhotosFromPublicDirectory(directory: string ) {

    const files = await readdir(directory, { recursive: true });

    const photoConfigs = await Promise.all(
        files
            .filter(filePath => filePath.endsWith('.json'))
            .map(filepath => path.join(directory, filepath))
            .map(filePath => readPhotoConfig(filePath))
    );

    // Sort images to show the newest first.
    photoConfigs.sort((a, b) => b.createSecondsEpoc - a.createSecondsEpoc)

    return photoConfigs;
}

